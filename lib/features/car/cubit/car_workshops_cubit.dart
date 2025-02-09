// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_workshops_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class CarWorkshopsCubit extends Cubit<BaseState> {
  final CarWorkshopsRepo carWorkshopsRepo;
  CarWorkshopsCubit({
    required this.carWorkshopsRepo,
  }) : super(const BaseInitialState());

  final int _limit = 10;

  List<CarWorkshop> workshops = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getWorkshops(int page) async {
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
      () => carWorkshopsRepo.getWorkshops(page, _limit),
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

  Future<void> deleteWorkshop(String id) async {
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

    await handleBaseCubit<void>(
      emit,
      () => carWorkshopsRepo.deleteWorkshop(id),
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
  }

  Future<void> refresh() => getWorkshops(1);
  Future<void> loadNextPage() => getWorkshops(currentPage + 1);

  Future<void> saveWorkshop(CarWorkshop carWorkshop) async {
    await handleBaseCubit<void>(
      emit,
      () => carWorkshopsRepo.saveWorkshop(carWorkshop),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(),
      },
    );
  }

  Future<void> updateWorkshop(CarWorkshop carWorkshop) async {
    await handleBaseCubit<void>(
      emit,
      () => carWorkshopsRepo.updateWorkshop(carWorkshop),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(),
      },
    );
  }
}
