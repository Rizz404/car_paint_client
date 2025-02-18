// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(admin)/cubit/admin_orders_cubit.dart';
import 'package:paint_car/features/(admin)/widgets/admin_orders_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class HomeAdmin extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const HomeAdmin());
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  late final CancelToken _cancelToken;

  late final ScrollController _scrollController;
  static const int limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<AdminOrdersCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<AdminOrdersCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<Orders>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<Orders>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage(_cancelToken);
    }
  }

  void _onRefresh() {
    context.read<AdminOrdersCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return StateHandler<AdminOrdersCubit, PaginationState<Orders>>(
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
                    (context, index) => AdminOrdersItem(
                      order: models[index],
                      cancelToken: _cancelToken,
                    ),
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
    );
  }
}
