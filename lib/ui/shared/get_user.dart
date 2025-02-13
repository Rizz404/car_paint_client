import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';

class GetUser extends StatefulWidget {
  const GetUser({super.key, required this.onSuccess});
  final Widget Function(UserWithProfile? user, UserRole role) onSuccess;

  @override
  State<GetUser> createState() => _GetUserState();
}

class _GetUserState extends State<GetUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, BaseState>(
      listener: (context, state) {
        if (state is BaseErrorState) {
          Navigator.of(context).pushReplacement(
            LoginPage.route(),
          );
        }
      },
      builder: (context, state) {
        final user =
            state is BaseSuccessState<UserWithProfile?> ? state.data : null;

        return widget.onSuccess(user, user?.role ?? UserRole.USER);
      },
    );
  }
}
