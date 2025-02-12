import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/auth/pages/login_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const UserPage());

  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    context.read<UserCubit>().getUserLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
      ),
      body: BlocBuilder<UserCubit, BaseState>(
        builder: (context, state) {
          if (state is BaseSuccessState<UserWithProfile?>) {
            final data = state.data;
            return Column(
              children: [
                MainText(text: data?.username ?? "No Token"),
                MainText(text: data?.role.name ?? "No Token"),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserCubit>().logout();
                    Navigator.of(context)
                        .pushAndRemoveUntil(LoginPage.route(), (_) => false);
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: () {
                context.read<UserCubit>().logout();
                Navigator.of(context)
                    .pushAndRemoveUntil(LoginPage.route(), (_) => false);
              },
              child: const Text('Logout, No Token'),
            );
          }
        },
      ),
    );
  }
}
