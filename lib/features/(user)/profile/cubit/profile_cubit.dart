// ignore_for_file: require_trailing_commas

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_cubit.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/profile/repo/profile_repo.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';

class ProfileCubit extends Cubit<BaseState> with Cancelable {
  final ProfileRepo userRepo;
  ProfileCubit({
    required this.userRepo,
  }) : super(const BaseInitialState());

  @override
  Future<void> close() {
    cancelRequests();
    return super.close();
  }

  Future<void> updateUser(
      UserWithProfile user, File? imageFile, CancelToken cancelToken) async {
    await handleBaseCubit<void>(
      emit,
      () => userRepo.updateUser(
        user,
        imageFile,
        cancelToken,
      ),
      onSuccess: (data, message) => {
        emit(const BaseActionSuccessState()),
      },
    );
  }
}
