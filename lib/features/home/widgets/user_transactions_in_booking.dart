import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_transactions_cubit.dart';
import 'package:paint_car/features/(user)/financial/widgets/user_transactions_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/common_state.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class UserTransactionsInBooking extends StatefulWidget {
  const UserTransactionsInBooking({super.key});

  @override
  State<UserTransactionsInBooking> createState() =>
      _UserTransactionsInBookingState();
}

class _UserTransactionsInBookingState extends State<UserTransactionsInBooking>
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
    final cubit = context.read<UserTransactionsCubit>();
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
    context
        .read<UserTransactionsCubit>()
        .refresh(ApiConstant.limit, cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StateHandler<UserTransactionsCubit, PaginationState<Transactions>>(
      onRetry: () => _onRefresh(),
      onSuccess: (context, data, message) {
        final models = data.data;
        if (models.isEmpty) {
          return const CommonState(
            title: 'Transaksi anda masih kosong',
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
                    (context, index) => UserTransactionsItem(
                      transactions: models[index],
                      onReturnFromWebView: _onRefresh,
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
