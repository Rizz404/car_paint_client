import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/template/repo/template_repo.dart';

class TemplateCubit extends Cubit<BaseState> {
  final TemplateRepo templateRepo;
  TemplateCubit({
    required this.templateRepo,
  }) : super(const BaseInitialState());

  Future<void> getBrands(int page, int limit) async {
    await handleBaseCubit<PaginatedData<CarBrand>>(
      emit,
      () => templateRepo.getBrands(page, limit),
    );
  }
}
