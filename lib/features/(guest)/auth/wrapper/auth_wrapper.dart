import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  Future<void> getUser() async {
    await context.read<UserCubit>().getUserLocal();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseSuccessState<UserWithProfile?>) {
          return const HomePage();
        } else if (state is BaseErrorState) {
          return const LoginPage();
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
