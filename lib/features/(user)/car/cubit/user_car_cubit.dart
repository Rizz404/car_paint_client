// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/car/repo/user_car_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class UserCarCubit extends Cubit<BaseState> with Cancelable {
  final UserCarRepo userCarRepo;
  UserCarCubit({
    required this.userCarRepo,
  }) : super(const BaseInitialState());

  List<UserCar> userCars = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> getUserCars(int page, CancelToken cancelToken,
      {int limit = 10}) async {
    if (isLoadingMore) return;
    cancelRequests();

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<UserCar>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<UserCar>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<UserCar>>(
            PaginationState<UserCar>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    try {
      await handleBaseCubit<PaginatedData<UserCar>>(
        emit,
        () => userCarRepo.getUserCars(page, limit, cancelToken),
        onSuccess: (data, message) {
          if (page == 1) userCars.clear();

          userCars.addAll(data.items);
          pagination = data.pagination;
          currentPage = page;
          isLoadingMore = false;

          emit(BaseSuccessState(
              PaginationState<UserCar>(
                data: userCars,
                pagination: pagination!,
                currentPage: currentPage,
                isLoadingMore: isLoadingMore,
              ),
              null));
        },
        withLoading: false,
      );
    } catch (e) {
      emit(BaseErrorState(message: 'Unexpected error: $e'));
    } finally {
      isLoadingMore = false;
    }
  }

  Future<void> deleteUserCar(String id, CancelToken cancelToken) async {
    final index = userCars.indexWhere((userCar) => userCar.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<UserCar>(
        data: userCars,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => userCarRepo.deleteUserCar(id, cancelToken),
      onSuccess: (_, __) => getUserCars(1, cancelToken),
    );
  }

  Future<void> refresh(int limit, CancelToken cancelToken) async {
    userCars.clear();
    pagination = null;
    currentPage = 1;
    isLoadingMore = false;
    emit(const BaseLoadingState());
    await getUserCars(1, cancelToken, limit: limit);
  }

  Future<void> loadNextPage(CancelToken cancelToken) =>
      getUserCars(currentPage + 1, cancelToken);

  Future<void> saveUserCar(UserCar userCarUserCar, List<File> imageFile,
      CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => userCarRepo.saveUserCar(userCarUserCar, imageFile, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getUserCars(1, cancelToken),
      },
    );
  }

  Future<void> updateUserCar(UserCar userCarUserCar, List<File>? imageFiles,
      CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => userCarRepo.updateUserCar(userCarUserCar, imageFiles, cancelToken),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getUserCars(1, cancelToken),
      },
    );
  }
}
