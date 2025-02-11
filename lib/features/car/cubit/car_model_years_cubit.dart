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

  List<CarModelYears> modelYears = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getModelYears(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

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
          if (page == 1) modelYears.clear();

          modelYears.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<CarModelYears>(
                data: modelYears,
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

  Future<void> deleteModelYear(String id, CancelToken cancelToken) async {
    final index = modelYears.indexWhere((modelYear) => modelYear.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarModelYears>(
        data: modelYears,
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
        modelYears.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarModelYears>(
            data: modelYears,
            pagination: pagination!,
            currentPage: currentPage,
            isLoadingMore: isLoadingMore,
          ),
          null,
        )),
      },
    );
  }

  // ! implementasiin di semuanya
  Future<void> refresh(int limit, CancelToken cancelToken) async {
    modelYears.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());

    await getModelYears(1, cancelToken, limit: limit);
  }

  Future<void> loadNextPage(CancelToken cancelToken) =>
      getModelYears(currentPage + 1, cancelToken);

  Future<void> saveModelYear(
      CarModelYears carModelYearsCarModelYears, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () =>
          carModelYearsRepo.saveModel(carModelYearsCarModelYears, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYears(1, cancelToken),
      },
    );
  }

  Future<void> updateModelYear(
      CarModelYears carModelYearsCarModelYears, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearsRepo.updateModel(
          carModelYearsCarModelYears, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYears(1, cancelToken),
      },
    );
  }
}
