// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/financial/repo/payment_method_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class PaymentMethodCubit extends Cubit<BaseState> {
  final PaymentMethodRepo paymentMethodRepo;
  PaymentMethodCubit({
    required this.paymentMethodRepo,
  }) : super(const BaseInitialState());

  List<PaymentMethod> modelYearColor = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getPaymentMethod(int page, {int limit = 10}) async {
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

    await handleBaseCubit<PaginatedData<PaymentMethod>>(
      emit,
      () => paymentMethodRepo.getModels(page, limit),
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
  }

  Future<void> loadNextPage() => getPaymentMethod(currentPage + 1);
  Future<void> refresh(
    int limit,
  ) =>
      getPaymentMethod(1, limit: limit);
}
