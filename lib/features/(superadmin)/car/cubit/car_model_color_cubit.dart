// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_model_color.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/repo/car_model_color_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarModelColorCubit extends Cubit<BaseState> with Cancelable {
  final CarModelColorRepo carModelColorRepo;
  CarModelColorCubit({
    required this.carModelColorRepo,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  List<CarModelColor> carModelColor = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getCarModelColor(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarModelColor>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarModelColor>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarModelColor>>(
            PaginationState<CarModelColor>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarModelColor>>(
      emit,
      () => carModelColorRepo.getCarModelColors(page, limit, cancelToken),
      onSuccess: (data, message) {
        if (page == 1) carModelColor.clear();

        carModelColor.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarModelColor>(
              data: carModelColor,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
      withLoading: false,
    );
  }

  Future<void> getCarModelColorsByModelId(
      String modelId, int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarModelColor>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarModelColor>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarModelColor>>(
            PaginationState<CarModelColor>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarModelColor>>(
      emit,
      () => carModelColorRepo.getCarModelColorsByModelId(
        page,
        limit,
        cancelToken,
        modelId,
      ),
      onSuccess: (data, message) {
        if (page == 1) carModelColor.clear();

        carModelColor.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarModelColor>(
              data: carModelColor,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
    );
  }

  Future<void> deleteModel(
    String id,
    CancelToken cancelToken,
  ) async {
    final index = carModelColor.indexWhere((model) => model.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarModelColor>(
        data: carModelColor,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    try {
      await handleBaseCubit<void>(
        emit,
        () => carModelColorRepo.deleteModel(id, cancelToken),
        onSuccess: (_, __) => {
          carModelColor.removeAt(index),
          emit(BaseSuccessState(
            PaginationState<CarModelColor>(
              data: carModelColor,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null,
          )),
        },
      );
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> refresh(
    int limit,
    CancelToken cancelToken,
  ) async {
    carModelColor.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());
    await getCarModelColor(1, cancelToken, limit: limit);
  }

  Future<void> loadNextPage(
    CancelToken cancelToken,
  ) =>
      getCarModelColor(currentPage + 1, cancelToken);

  Future<void> saveModel(
    CarModelColor carModelColor,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelColorRepo.saveModel(carModelColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getCarModelColor(1, cancelToken),
      },
    );
  }

  Future<void> updateModel(
    CarModelColor carModelColor,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelColorRepo.updateModel(carModelColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getCarModelColor(1, cancelToken),
      },
    );
  }
}
