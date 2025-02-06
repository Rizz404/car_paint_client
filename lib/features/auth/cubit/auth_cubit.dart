import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/auth/repo/auth_repo.dart';

class AuthCubit extends Cubit<BaseState> {
  final AuthRepo authRepo;
  AuthCubit({
    required this.authRepo,
  }) : super(const BaseInitialState());

  Future<void> register(
    String username,
    String email,
    String password,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => authRepo.register(username, email, password),
    );
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    await handleBaseCubit<void>(
      emit,
      () => authRepo.login(email, password),
    );
  }
}
