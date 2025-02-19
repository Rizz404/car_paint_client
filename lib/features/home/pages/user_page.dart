import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/(user)/profile/pages/profile_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/circle_image_network.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
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
    return BlocBuilder<UserCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseSuccessState<UserWithProfile?>) {
          final data = state.data;
          return SingleChildScrollView(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 16,
                          children: [
                            CircleImageNetwork(
                              imageUrl: data?.profileImage,
                              radius: 36,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MainText(
                                  text: " ${data?.username}",
                                  extent: const Medium(),
                                ),
                                MainText(
                                  text: " ${data?.email}",
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              ProfilePage.route(
                                user: data!,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
                const MainText(text: "Action", extent: Medium())
                    .paddingSymmetric(
                  horizontal: 16,
                ),
                Material(
                  color: Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () {
                      context.read<UserCubit>().logout();
                      Navigator.of(context)
                          .pushAndRemoveUntil(LoginPage.route(), (_) => false);
                    },
                    child: ListTile(
                      title: const MainText(text: "Logout"),
                      leading: const Icon(Icons.logout),
                    ),
                  ),
                )
              ],
            ),
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
    );
  }
}
