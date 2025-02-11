// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_model_years_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarModelYearsCubit extends Cubit<BaseState> with Cancelable {
  final CarModelYearsRepo carModelYearsRepo;
  CarModelYearsCubit({
    required this.carModelYearsRepo,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  List<CarModelYears> modelYear = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getModelYear(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    cancelRequests();

    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarModelYears>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarModelYears>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarModelYears>>(
            PaginationState<CarModelYears>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    try {
      await handleBaseCubit<PaginatedData<CarModelYears>>(
        emit,
        () => carModelYearsRepo.getModelYears(page, limit, cancelToken),
        onSuccess: (data, message) {
          if (page == 1) modelYear.clear();

          modelYear.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<CarModelYears>(
                data: modelYear,
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

  Future<void> deleteModel(
    String id,
    CancelToken cancelToken,
  ) async {
    final index = modelYear.indexWhere((model) => model.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarModelYears>(
        data: modelYear,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carModelYearsRepo.deleteModel(id, cancelToken),
      onSuccess: (_, __) => {
        modelYear.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarModelYears>(
            data: modelYear,
            pagination: pagination!,
            currentPage: currentPage,
            isLoadingMore: isLoadingMore,
          ),
          null,
        )),
      },
    );
  }

  Future<void> refresh(
    int limit,
    CancelToken cancelToken,
  ) =>
      getModelYear(1, limit: limit, cancelToken);
  Future<void> loadNextPage() => getModelYear(currentPage + 1, cancelToken);

  Future<void> saveModel(
    CarModelYears carModelYears,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearsRepo.saveModel(carModelYears, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYear(1, cancelToken),
      },
    );
  }

  Future<void> updateModel(
    CarModelYears carModelYears,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearsRepo.updateModel(carModelYears, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYear(1, cancelToken),
      },
    );
  }
}
