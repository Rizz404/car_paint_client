import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(guest)/auth/repo/auth_repo.dart';
import 'package:paint_car/features/cubit/notification_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class AuthCubit extends Cubit<BaseState> with Cancelable {
  final AuthRepo authRepo;
  // final NotificationCubit notificationCubit;

  AuthCubit({
    required this.authRepo,
    // required this.notificationCubit,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> register(
    String username,
    String email,
    String password,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => authRepo.register(username, email, password, cancelToken),
      onSuccess: (data, message) => emit(const BaseActionSuccessState()),
    );
  }

  Future<void> login(
    String email,
    String password,
    CancelToken cancelToken,
  ) async {
    await handleBaseCubit<UserWithProfile>(
      emit,
      () => authRepo.login(email, password, cancelToken),
      onSuccess: (data, message) {
        debugPrint(message);
        // notificationCubit.reinitialize();
        emit(const BaseActionSuccessState());
      },
    );
  }
}
