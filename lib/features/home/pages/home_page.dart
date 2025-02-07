import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/auth/pages/login_page.dart';
import 'package:paint_car/features/template/cubit/template_cubit.dart';
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
    context.read<TemplateCubit>().getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocConsumer<TemplateCubit, BaseState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is BaseSuccessState<String?>) {
            final data = state.data;
            return Column(
              children: [
                MainText(text: data ?? "No Token"),
                ElevatedButton(
                  onPressed: () {
                    context.read<TemplateCubit>().logout();
                    Navigator.of(context)
                        .pushAndRemoveUntil(LoginPage.route(), (_) => false);
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          } else {
            return const MainText(text: 'Else');
          }
        },
      ),
    );
  }
}
