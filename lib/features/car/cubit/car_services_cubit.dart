// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_services_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class CarServicesCubit extends Cubit<BaseState> {
  final CarServicesRepo carServicesRepo;
  CarServicesCubit({
    required this.carServicesRepo,
  }) : super(const BaseInitialState());

  final int _limit = 10;

  List<CarService> services = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getServices(int page) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarService>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarService>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarService>>(
            PaginationState<CarService>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarService>>(
      emit,
      () => carServicesRepo.getServices(page, _limit),
      onSuccess: (data, message) {
        if (page == 1) services.clear();

        services.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarService>(
              data: services,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
      withLoading: false,
    );
  }

  Future<void> deleteService(String id) async {
    final index = services.indexWhere((service) => service.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarService>(
        data: services,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.deleteService(id),
      onSuccess: (_, __) => {
        services.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarService>(
            data: services,
            pagination: pagination!,
            currentPage: currentPage,
            isLoadingMore: isLoadingMore,
          ),
          null,
        )),
      },
    );
  }

  Future<void> refresh() => getServices(1);
  Future<void> loadNextPage() => getServices(currentPage + 1);

  Future<void> saveService(CarService carService) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.saveService(carService),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(),
      },
    );
  }

  Future<void> saveManyServices(List<CarService> carServices) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.saveManyServices(carServices),
      onSuccess: (data, message) {
        emit(const BaseActionSuccessState());
        refresh();
      },
    );
  }

  Future<void> updateService(CarService carService) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.updateService(carService),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(),
      },
    );
  }
}
