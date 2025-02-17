// ignore_for_file: require_trailing_commas

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/workshop/repo/user_workshops_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class UserWorkshopCubit extends Cubit<BaseState> with Cancelable {
  final UserWorkshopsRepo userWorkshopRepo;
  UserWorkshopCubit({
    required this.userWorkshopRepo,
  }) : super(const BaseInitialState());

  List<CarWorkshop> workshops = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getWorkshops(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

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

    try {
      await handleBaseCubit<PaginatedData<CarWorkshop>>(
        emit,
        () => userWorkshopRepo.getWorkshops(page, limit, cancelToken),
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
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> deleteWorkshop(String id, CancelToken cancelToken) async {
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
      () => userWorkshopRepo.deleteWorkshop(id, cancelToken),
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

  // ! implementasiin di semuanya
  Future<void> refresh(int limit, CancelToken cancelToken) async {
    workshops.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());

    await getWorkshops(1, cancelToken, limit: limit);
  }

  Future<void> loadNextPage(CancelToken cancelToken) =>
      getWorkshops(currentPage + 1, cancelToken);

  Future<void> saveWorkshop(
      CarWorkshop carWorkshopCarWorkshop, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => userWorkshopRepo.saveWorkshop(carWorkshopCarWorkshop, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getWorkshops(1, cancelToken),
      },
    );
  }

  Future<void> getNearestWorkshops(
      int page, double latitude, double longitude, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

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

    try {
      await handleBaseCubit<PaginatedData<CarWorkshop>>(
        emit,
        () => userWorkshopRepo.getNearestWorkshop(
          page,
          limit,
          latitude,
          longitude,
          cancelToken,
        ),
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
    } catch (e) {
      emit(BaseErrorState(message: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> updateWorkshop(
      CarWorkshop carWorkshopCarWorkshop, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () =>
          userWorkshopRepo.updateWorkshop(carWorkshopCarWorkshop, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getWorkshops(1, cancelToken),
      },
    );
  }
}
