// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_brands_repo.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';

class CarBrandsCubit extends Cubit<BaseState> {
  final CarBrandsRepo carBrandsRepo;
  CarBrandsCubit({
    required this.carBrandsRepo,
  }) : super(const BaseInitialState());

  List<CarBrand> brands = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLoadingMore = false;

  Future<void> getBrands(int page, {int limit = 10}) async {
    if (isLoadingMore) return;

    isLoadingMore = page != 1;

    if (page == 1) {
      emit(const BaseLoadingState());
    } else {
      // kalo dah ada data, update state buat tampilin loading di bagian bawah
      if (state is BaseSuccessState<PaginationState<CarBrand>>) {
        final currentState =
            state as BaseSuccessState<PaginationState<CarBrand>>;
        final data = currentState.data;
        emit(BaseSuccessState<PaginationState<CarBrand>>(
            PaginationState<CarBrand>(
              data: data.data,
              pagination: data.pagination,
              currentPage: data.currentPage,
              isLoadingMore: true,
            ),
            null));
      }
    }

    await handleBaseCubit<PaginatedData<CarBrand>>(
      emit,
      () => carBrandsRepo.getBrands(page, limit),
      onSuccess: (data, message) {
        if (page == 1) brands.clear();

        brands.addAll(data.items);
        pagination = data.pagination;
        currentPage = page;
        isLoadingMore = false;

        emit(BaseSuccessState(
            PaginationState<CarBrand>(
              data: brands,
              pagination: pagination!,
              currentPage: currentPage,
              isLoadingMore: isLoadingMore,
            ),
            null));
      },
      withLoading: false,
    );
  }

  Future<void> deleteBrand(String id) async {
    final index = brands.indexWhere((brand) => brand.id == id);
    if (index == -1) return;

    emit(BaseSuccessState(
      PaginationState<CarBrand>(
        data: brands,
        pagination: pagination!,
        currentPage: currentPage,
        isLoadingMore: isLoadingMore,
      ),
      null,
    ));

    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.deleteBrand(id),
      onSuccess: (_, __) => getBrands(1),
    );
  }

  Future<void> refresh(
    int limit,
  ) =>
      getBrands(1, limit: limit);
  Future<void> loadNextPage() => getBrands(currentPage + 1);

  Future<void> saveBrand(CarBrand carBrand, File imageFile) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.saveBrand(carBrand, imageFile),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getBrands(1),
      },
    );
  }

  Future<void> saveManyBrands(
      List<CarBrand> carBrands, List<File> imageFiles) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.saveManyBrands(carBrands, imageFiles),
      onSuccess: (data, message) {
        emit(const BaseActionSuccessState());
        getBrands(1); // Refresh list brands
      },
    );
  }

  Future<void> updateBrand(CarBrand carBrand, File? imageFile) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.updateBrand(carBrand, imageFile),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getBrands(1),
      },
    );
  }
}
