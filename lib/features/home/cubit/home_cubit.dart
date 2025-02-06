import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/home/repo/home_repo.dart';

class HomeCubit extends Cubit<BaseState> {
  final HomeRepo homeRepo;
  HomeCubit({
    required this.homeRepo,
  }) : super(BaseInitialState());

  Future<void> getBrands(int page, int limit) async {
    await handleBaseCubit<PaginatedData<CarBrand>>(
      emit,
      () => homeRepo.getBrands(page, limit),
    );
  }
}
