import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/(user)/profile/pages/profile_page.dart';
import 'package:paint_car/features/shared/cubit/theme_cubit.dart';
import 'package:paint_car/features/shared/cubit/theme_state.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/circle_image_network.dart';
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
                    Container(
                      color: context.adaptiveCommonColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      child: Row(
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
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                  ],
                ),
                const MainText(text: "Aksi", extent: Medium()).paddingSymmetric(
                  horizontal: 16,
                ),
                Material(
                  color: context.adaptiveCommonColor,
                  child: InkWell(
                    onTap: () {
                      context.read<UserCubit>().logout();
                      Navigator.of(context)
                          .pushAndRemoveUntil(LoginPage.route(), (_) => false);
                    },
                    child: const ListTile(
                      title: MainText(text: "Keluar"),
                      leading: Icon(Icons.logout),
                    ),
                  ),
                ),
                Material(
                  color: context.adaptiveCommonColor,
                  child: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, themeState) {
                      return SwitchListTile(
                        activeColor: CustomColors.guideRed,
                        tileColor: context.adaptiveCommonColor,
                        hoverColor: CustomColors.guideRed.withOpacity(0.1),
                        thumbColor: MaterialStateProperty.all(
                          CustomColors.guideRed,
                        ),
                        trackColor: WidgetStateProperty.all(
                          CustomColors.guideRed.withOpacity(0.3),
                        ),
                        overlayColor: WidgetStateProperty.all(
                          CustomColors.guideRed.withOpacity(0.1),
                        ),
                        activeTrackColor:
                            CustomColors.guideRed.withOpacity(0.3),
                        title: const MainText(text: "Mode Gelap"),
                        secondary: Icon(
                          themeState.status == ThemeStatus.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                        value: themeState.status == ThemeStatus.dark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(vertical: 16);
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
    ).paddingSymmetric(vertical: 24);
  }
}
