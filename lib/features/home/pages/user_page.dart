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
                                    color: context.adaptiveTextColor,
                                  ),
                                  MainText(
                                    text: " ${data?.email}",
                                    color: context.adaptiveTextColor,
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
                            icon: Icon(
                              Icons.edit,
                              color: context.adaptiveTextColor,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ),
                    const Divider(
                      thickness: 1,
                    ).paddingSymmetric(horizontal: 20),
                  ],
                ),
                MainText(
                  text: "Aksi",
                  extent: const Medium(),
                  color: context.adaptiveTextColor,
                ).paddingSymmetric(
                  horizontal: 20,
                ),
                Column(
                  spacing: 8,
                  children: [
                    Material(
                      color: context.adaptiveCommonColor,
                      child: InkWell(
                        onTap: () {
                          context.read<UserCubit>().logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            LoginPage.route(),
                            (_) => false,
                          );
                        },
                        child: ListTile(
                          title: MainText(
                            text: "Keluar",
                            color: context.adaptiveTextColor,
                          ),
                          leading: Icon(
                            Icons.logout,
                            color: context.adaptiveTextColor,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: context.adaptiveCommonColor,
                      child: BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, themeState) {
                          return SwitchListTile(
                            activeColor: context.adaptiveSecondaryTextColor,
                            hoverColor: context.adaptiveSecondaryTextColor
                                .withOpacity(0.1),
                            thumbColor: MaterialStateProperty.all(
                              context.adaptiveSecondaryTextColor,
                            ),
                            trackColor: WidgetStateProperty.all(
                              context.adaptiveSecondaryTextColor
                                  .withOpacity(0.3),
                            ),
                            overlayColor: WidgetStateProperty.all(
                              context.adaptiveSecondaryTextColor
                                  .withOpacity(0.1),
                            ),
                            activeTrackColor: context.adaptiveSecondaryTextColor
                                .withOpacity(0.3),
                            title: MainText(
                              text: "Mode Gelap",
                              color: context.adaptiveTextColor,
                            ),
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
                ).paddingSymmetric(horizontal: 20),
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
