import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/repo/car_brands_repo.dart';

class CarBrandsCubit extends Cubit<BaseState> {
  final CarBrandsRepo carBrandsRepo;
  CarBrandsCubit({
    required this.carBrandsRepo,
  }) : super(const BaseInitialState());

  Future<void> getBrands(int page, int limit) async {
    await handleBaseCubit<PaginatedData<CarBrand>>(
      emit,
      () => carBrandsRepo.getBrands(page, limit),
      onSuccess: (data, message) =>
          emit(BaseSuccessState<PaginatedData<CarBrand>>(data, message)),
      withLoading: false,
    );
  }

  Future<void> saveBrand(CarBrand carBrand, File imageFile) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.saveBrand(carBrand, imageFile),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getBrands(1, 10),
      },
    );
  }

  Future<void> updateBrand(CarBrand carBrand, File? imageFile) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.updateBrand(carBrand, imageFile),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getBrands(1, 10),
      },
    );
  }

  Future<void> deleteBrand(String id) async {
    await handleBaseCubit<void>(
      emit,
      () => carBrandsRepo.deleteBrand(id),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
        getBrands(1, 10),
      },
    );
  }
}
