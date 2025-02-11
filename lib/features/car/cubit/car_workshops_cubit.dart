// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_workshops_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarWorkshopsCubit extends Cubit<BaseState> with Cancelable {
  final CarWorkshopsRepo carWorkshopsRepo;
  CarWorkshopsCubit({
    required this.carWorkshopsRepo,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  final int _limit = 10;

  List<CarWorkshop> workshops = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getWorkshops(
    int page,
    CancelToken cancelToken,
  ) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarWorkshop>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarWorkshop>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarWorkshop>>(
            PaginationState<CarWorkshop>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarWorkshop>>(
      emit,
      () => carWorkshopsRepo.getWorkshops(page, _limit, cancelToken),
      onSuccess: (data, message) {
        if (page == 1) workshops.clear();

        workshops.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarWorkshop>(
              data: workshops,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
      withLoading: false,
    );
  }

  Future<void> deleteWorkshop(
    String id,
    CancelToken cancelToken,
  ) async {
    final index = workshops.indexWhere((workshop) => workshop.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarWorkshop>(
        data: workshops,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    try {
      await handleBaseCubit<void>(
        emit,
        () => carWorkshopsRepo.deleteWorkshop(id, cancelToken),
        onSuccess: (_, __) => {
          workshops.removeAt(index),
          emit(BaseSuccessState(
            PaginationState<CarWorkshop>(
              data: workshops,
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
    CancelToken cancelToken,
  ) =>
      getWorkshops(1, cancelToken);
  Future<void> loadNextPage(
    CancelToken cancelToken,
  ) =>
      getWorkshops(currentPage + 1, cancelToken);

  Future<void> saveWorkshop(
    CarWorkshop carWorkshop,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carWorkshopsRepo.saveWorkshop(carWorkshop, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(cancelToken),
      },
    );
  }

  Future<void> updateWorkshop(
    CarWorkshop carWorkshop,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carWorkshopsRepo.updateWorkshop(carWorkshop, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(cancelToken),
      },
    );
  }
}
