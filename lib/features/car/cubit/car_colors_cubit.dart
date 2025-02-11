// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_colors_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarColorsCubit extends Cubit<BaseState> with Cancelable {
  final CarColorsRepo carColorsRepo;
  CarColorsCubit({
    required this.carColorsRepo,
  }) : super(const BaseInitialState());

  List<CarColor> colors = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getColors(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    cancelRequests();

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

    try {
      await handleBaseCubit<PaginatedData<CarColor>>(
        emit,
        () => carColorsRepo.getColors(page, limit, cancelToken),
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
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> deleteColor(String id, CancelToken cancelToken) async {
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
      () => carColorsRepo.deleteColor(id, cancelToken),
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

  // ! implementasiin di semuanya
  Future<void> refresh(int limit, CancelToken cancelToken) async {
    colors.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());

    await getColors(1, cancelToken, limit: limit);
  }

  Future<void> loadNextPage(CancelToken cancelToken) =>
      getColors(currentPage + 1, cancelToken);

  Future<void> saveColor(CarColor carColor, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => carColorsRepo.saveColor(carColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getColors(1, cancelToken),
      },
    );
  }

  Future<void> updateColor(CarColor carColor, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => carColorsRepo.updateColor(carColor, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getColors(1, cancelToken),
      },
    );
  }
}
