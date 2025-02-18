// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(admin)/repo/admin_orders_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class AdminOrdersCubit extends Cubit<BaseState> with Cancelable {
  final AdminOrdersRepo adminOrdersCubit;
  AdminOrdersCubit({
    required this.adminOrdersCubit,
  }) : super(const BaseInitialState());

  List<Orders> orders = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getOrders(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    cancelRequests();

    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<Orders>>) {
        final currentState = state as BaseSuccessState<PaginationState<Orders>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<Orders>>(
            PaginationState<Orders>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    try {
      await handleBaseCubit<PaginatedData<Orders>>(
        emit,
        () => adminOrdersCubit.getOrders(page, limit, cancelToken),
        onSuccess: (data, message) {
          if (page == 1) orders.clear();

          orders.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<Orders>(
                data: orders,
                pagination: pagination!,
                currentPage: currentPage,
                isLoadingMore: isLoadingMore,
              ),
              null));
        },
        withLoading: false,
      );
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> loadNextPage(
    CancelToken cancelToken,
  ) =>
      getOrders(currentPage + 1, cancelToken);
  Future<void> refresh(
    int limit,
    CancelToken cancelToken,
  ) async {
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());
    await getOrders(currentPage, cancelToken, limit: limit);
  }

  Future<void> cancelOrder(
    String orderId,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => adminOrdersCubit.cancelOrder(
        cancelToken,
        orderId,
      ),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getOrders(1, cancelToken),
      },
    );
  }
}
