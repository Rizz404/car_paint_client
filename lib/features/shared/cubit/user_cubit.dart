import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/cubit/notification_cubit.dart';
import 'package:paint_car/features/shared/repo/user_repo.dart';

class UserCubit extends Cubit<BaseState> {
  final UserRepo userRepo;
  final NotificationCubit notificationCubit;

  UserCubit({
    required this.userRepo,
    required this.notificationCubit,
  }) : super(const BaseInitialState());

  Future<void> getUserLocal() async {
    final user = await userRepo.getUserLocal();
    if (user != null) {
      emit(BaseSuccessState<UserWithProfile?>(user, null));
    } else {
      emit(
        const BaseErrorState(),
      );
    }
  }

  Future<void> logout() async {
    notificationCubit.resetState();
    await userRepo.logout();
    emit(const BaseInitialState());
  }

  Future<void> getToken() async {
    final token = await userRepo.getToken();
    if (token != null) {
      emit(BaseSuccessState<String?>(token, null));
    } else {
      emit(
        const BaseErrorState(
          message: "Token not found",
        ),
      );
    }
  }
}
