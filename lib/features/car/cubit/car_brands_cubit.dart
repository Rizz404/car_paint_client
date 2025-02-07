import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/auth/repo/auth_repo.dart';

class CarBrandsCubit extends Cubit<BaseState> {
  final AuthRepo authRepo;
  CarBrandsCubit({
    required this.authRepo,
  }) : super(const BaseInitialState());
}
