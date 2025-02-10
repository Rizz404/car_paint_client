// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_model_year_color_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class CarModelYearColorCubit extends Cubit<BaseState> {
  final CarModelYearColorRepo carModelYearColorRepo;
  CarModelYearColorCubit({
    required this.carModelYearColorRepo,
  }) : super(const BaseInitialState());

  List<CarModelYearColor> modelYearColor = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getModelYearColor(int page, {int limit = 10}) async {
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
      () => carModelYearColorRepo.getModels(page, limit),
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

  Future<void> deleteModel(String id) async {
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
      () => carModelYearColorRepo.deleteModel(id),
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
  ) =>
      getModelYearColor(1, limit: limit);
  Future<void> loadNextPage() => getModelYearColor(currentPage + 1);

  Future<void> saveModel(CarModelYearColor carModelYearColor) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearColorRepo.saveModel(carModelYearColor),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYearColor(1),
      },
    );
  }

  Future<void> updateModel(CarModelYearColor carModelYearColor) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelYearColorRepo.updateModel(carModelYearColor),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModelYearColor(1),
      },
    );
  }
}
