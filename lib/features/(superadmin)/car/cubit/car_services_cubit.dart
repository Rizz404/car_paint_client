// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/repo/car_services_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarServicesCubit extends Cubit<BaseState> with Cancelable {
  final CarServicesRepo carServicesRepo;
  CarServicesCubit({
    required this.carServicesRepo,
  }) : super(const BaseInitialState());

  List<CarService> services = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getServices(
    int page,
    CancelToken cancelToken, {
    int limit = 10,
  }) async {
    if (isLoadingMore) return;
    cancelRequests();

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

    try {
      await handleBaseCubit<PaginatedData<CarService>>(
        emit,
        () => carServicesRepo.getServices(page, limit, cancelToken),
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
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> deleteService(
    String id,
    CancelToken cancelToken,
  ) async {
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
      () => carServicesRepo.deleteService(id, cancelToken),
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

  Future<void> refresh(
    CancelToken cancelToken,
  ) async {
    services.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());
    await getServices(1, cancelToken);
  }

  Future<void> loadNextPage(
    CancelToken cancelToken,
  ) =>
      getServices(currentPage + 1, cancelToken);

  Future<void> saveService(
    CarService carService,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.saveService(carService, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(cancelToken),
      },
    );
  }

  Future<void> saveManyServices(
    List<CarService> carServices,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.saveManyServices(carServices, cancelToken),
      onSuccess: (data, message) {
        emit(const BaseActionSuccessState());
        refresh(cancelToken);
      },
    );
  }

  Future<void> updateService(
    CarService carService,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carServicesRepo.updateService(carService, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        refresh(cancelToken),
      },
    );
  }
}
