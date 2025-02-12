// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/financial/repo/payment_method_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class PaymentMethodCubit extends Cubit<BaseState> with Cancelable {
  final PaymentMethodRepo paymentMethodRepo;
  PaymentMethodCubit({
    required this.paymentMethodRepo,
  }) : super(const BaseInitialState());

  List<PaymentMethod> modelYearColor = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;
  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getPaymentMethod(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    cancelRequests();

    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<PaymentMethod>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<PaymentMethod>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<PaymentMethod>>(
            PaginationState<PaymentMethod>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    try {
      await handleBaseCubit<PaginatedData<PaymentMethod>>(
        emit,
        () => paymentMethodRepo.getModels(page, limit, cancelToken),
        onSuccess: (data, message) {
          if (page == 1) modelYearColor.clear();

          modelYearColor.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<PaymentMethod>(
                data: modelYearColor,
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
      getPaymentMethod(currentPage + 1, cancelToken);
  Future<void> refresh(
    int limit,
    CancelToken cancelToken,
  ) async {
    modelYearColor.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());
    await getPaymentMethod(currentPage, cancelToken, limit: limit);
  }
}
