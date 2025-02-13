import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';

extension UserContextExtension on BuildContext {
  UserWithProfile? get currentUser {
    try {
      final state = BlocProvider.of<UserCubit>(this).state;
      if (state is BaseSuccessState<UserWithProfile?>) {
        return state.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  UserRole get userRole => currentUser?.role ?? UserRole.USER;
}
