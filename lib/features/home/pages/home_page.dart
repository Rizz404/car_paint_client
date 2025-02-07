import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/auth/pages/login_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<UserCubit>().getUserLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocBuilder<UserCubit, BaseState>(
        builder: (context, state) {
          if (state is BaseSuccessState<UserWithProfile?>) {
            final data = state.data;
            return Column(
              children: [
                MainText(text: data?.username ?? "No Token"),
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
