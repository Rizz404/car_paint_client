// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_model_year_color_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarModelYearColorCubit extends Cubit<BaseState> with Cancelable {
  final CarModelYearColorRepo carModelYearColorRepo;
  CarModelYearColorCubit({
    required this.carModelYearColorRepo,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  List<CarModelYearColor> modelYearColor = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getModelYearColor(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarModelYearColor>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarModelYearColor>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarModelYearColor>>(
            PaginationState<CarModelYearColor>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarModelYearColor>>(
      emit,
      () => carModelYearColorRepo.getModels(page, limit, cancelToken),
      onSuccess: (data, message) {
        if (page == 1) modelYearColor.clear();

        modelYearColor.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarModelYearColor>(
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

  Future<void> deleteModel(
    String id,
    CancelToken cancelToken,
  ) async {
    final index = modelYearColor.indexWhere((model) => model.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarModelYearColor>(
        data: modelYearColor,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carModelYearColorRepo.deleteModel(id, cancelToken),
      onSuccess: (_, __) => {
        modelYearColor.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarModelYearColor>(
            data: modelYearColor,
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
      getModelYearColor(1, limit: limit, cancelToken);
  Future<void> loadNextPage(
    CancelToken cancelToken,
  ) =>
      getModelYearColor(currentPage + 1, cancelToken);

  Future<void> saveModel(
    CarModelYearColor carModelYearColor,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearColorRepo.saveModel(carModelYearColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYearColor(1, cancelToken),
      },
    );
  }

  Future<void> updateModel(
    CarModelYearColor carModelYearColor,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearColorRepo.updateModel(carModelYearColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYearColor(1, cancelToken),
      },
    );
  }
}
