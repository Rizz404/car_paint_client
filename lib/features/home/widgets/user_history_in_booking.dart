import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_history_cubit.dart';
import 'package:paint_car/features/(user)/financial/widgets/user_history_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/common_state.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class UserHistoryInBooking extends StatefulWidget {
  const UserHistoryInBooking({super.key});

  @override
  State<UserHistoryInBooking> createState() => _UserHistoryInBookingState();
}

class _UserHistoryInBookingState extends State<UserHistoryInBooking>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
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
      final cancelToken = CancelToken();
      cubit.loadNextPage(cancelToken);
    }
  }

  void _onRefresh() {
    final cancelToken = CancelToken();
    context.read<UserHistoryCubit>().refresh(ApiConstant.limit, cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StateHandler<UserHistoryCubit, PaginationState<Transactions>>(
      onRetry: () => _onRefresh(),
      onSuccess: (context, data, message) {
        final models = data.data;
        if (models.isEmpty) {
          return const CommonState(
            title: 'History anda masih kosong',
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _onRefresh(),
          child: Scrollbar(
            controller: _scrollController,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => UserHistoryItem(
                      transactions: models[index],
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
