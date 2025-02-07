import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/shared/repo/user_repo.dart';

class UserCubit extends Cubit<BaseState> {
  final UserRepo userRepo;
  UserCubit({
    required this.userRepo,
  }) : super(const BaseInitialState());

  Future<void> getUserLocal() async {
    final user = await userRepo.getUserLocal();
    if (user != null) {
      emit(BaseSuccessState<UserWithProfile?>(user, null));
    } else {
      emit(
        const BaseErrorState(
          message: "User not found",
        ),
      );
    }
  }

  Future<void> logout() async {
    await userRepo.logout();
  }
}
