// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_models_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class CarModelsCubit extends Cubit<BaseState> with Cancelable {
  final CarModelsRepo carModelsRepo;
  CarModelsCubit({
    required this.carModelsRepo,
  }) : super(const BaseInitialState());

  List<CarModel> models = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getModels(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarModel>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarModel>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarModel>>(
            PaginationState<CarModel>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    try {
      await handleBaseCubit<PaginatedData<CarModel>>(
        emit,
        () => carModelsRepo.getModels(page, limit, cancelToken),
        onSuccess: (data, message) {
          if (page == 1) models.clear();

          models.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<CarModel>(
                data: models,
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

  Future<void> deleteModel(
    String id,
    CancelToken cancelToken,
  ) async {
    final index = models.indexWhere((model) => model.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarModel>(
        data: models,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carModelsRepo.deleteModel(id, cancelToken),
      onSuccess: (_, __) => {
        models.removeAt(index),
        emit(BaseSuccessState(
          PaginationState<CarModel>(
            data: models,
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
      getModels(1, limit: limit, cancelToken);
  Future<void> loadNextPage() => getModels(currentPage + 1, cancelToken);

  Future<void> saveModel(CarModel carModel) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelsRepo.saveModel(carModel, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModels(1, cancelToken),
      },
    );
  }

  Future<void> saveManyModels(
    List<CarModel> carModels,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelsRepo.saveManyModels(carModels, cancelToken),
      onSuccess: (data, message) {
        emit(const BaseActionSuccessState());
        getModels(1, cancelToken);
      },
    );
  }

  Future<void> updateModel(
    CarModel carModel,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => carModelsRepo.updateModel(carModel, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getModels(1, cancelToken),
      },
    );
  }
}
