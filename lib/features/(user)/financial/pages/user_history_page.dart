// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
// ignore: unused_import
import 'package:paint_car/data/models/e_ticket.dart';
// ignore: unused_import
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_history_cubit.dart';
import 'package:paint_car/features/(user)/financial/widgets/user_history_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class UserHistoryPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const UserHistoryPage());
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  late final ScrollController _scrollController;
  late final CancelToken _cancelToken;

  static const int limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<UserHistoryCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<UserHistoryCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<Transactions>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<Transactions>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage(_cancelToken);
    }
  }

  void _onRefresh() {
    context.read<UserHistoryCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("History"),
      body: StateHandler<UserHistoryCubit, PaginationState<Transactions>>(
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
                      (context, index) =>
                          UserHistoryItem(transactions: models[index]),
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
