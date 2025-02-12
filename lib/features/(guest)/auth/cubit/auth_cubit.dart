import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(guest)/auth/repo/auth_repo.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class AuthCubit extends Cubit<BaseState> with Cancelable {
  final AuthRepo authRepo;
  AuthCubit({
    required this.authRepo,
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
    await handleBaseCubit<void>(
      emit,
      () => authRepo.login(email, password, cancelToken),
      onSuccess: (data, message) => emit(const BaseActionSuccessState()),
    );
  }
}
