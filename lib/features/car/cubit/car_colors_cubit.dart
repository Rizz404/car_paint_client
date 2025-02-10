// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_colors_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class CarColorsCubit extends Cubit<BaseState> {
  final CarColorsRepo carColorsRepo;
  CarColorsCubit({
    required this.carColorsRepo,
  }) : super(const BaseInitialState());

  List<CarColor> colors = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getColors(int page, {int limit = 10}) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarColor>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarColor>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarColor>>(
            PaginationState<CarColor>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarColor>>(
      emit,
      () => carColorsRepo.getColors(page, limit),
      onSuccess: (data, message) {
        if (page == 1) colors.clear();

        colors.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarColor>(
              data: colors,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
      withLoading: false,
    );
  }

  Future<void> deleteColor(String id) async {
    final index = colors.indexWhere((color) => color.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarColor>(
        data: colors,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carColorsRepo.deleteColor(id),
      onSuccess: (_, __) => {
        colors.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarColor>(
            data: colors,
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
      getColors(1, limit: limit);
  Future<void> loadNextPage() => getColors(currentPage + 1);

  Future<void> saveColor(CarColor carColor) async {
    await handleBaseCubit<void>(
      emit,
      () => carColorsRepo.saveColor(carColor),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getColors(1),
      },
    );
  }

  Future<void> updateColor(CarColor carColor) async {
    await handleBaseCubit<void>(
      emit,
      () => carColorsRepo.updateColor(carColor),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getColors(1),
      },
    );
  }
}
