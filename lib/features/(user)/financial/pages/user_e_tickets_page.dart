// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/e_ticket.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/widgets/e_tickets_item.dart';
import 'package:paint_car/features/(user)/financial/user_e_tickets_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class UserETicketsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const UserETicketsPage());
  const UserETicketsPage({super.key});

  @override
  State<UserETicketsPage> createState() => _UserETicketsPageState();
}

class _UserETicketsPageState extends State<UserETicketsPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;
  static const int limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<UserETicketsCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<UserETicketsCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<ETicket>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<ETicket>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage(_cancelToken);
    }
  }

  void _onRefresh() {
    context.read<UserETicketsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("ETickets"),
      body: StateHandler<UserETicketsCubit, PaginationState<ETicket>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final models = data.data;

          return RefreshIndicator(
            onRefresh: () async {
              _onRefresh();
            },
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: CustomScrollView(
                cacheExtent: 2000, // ! Preload area di luar viewport
                controller: _scrollController,
                physics:
                    const AlwaysScrollableScrollPhysics(), // buat RefreshIndicator
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ETicketsItem(ticket: models[index]),
                      childCount: models.length,
                    ),
                  ),
                  if (data.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Loading(),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
