import 'package:flutter/material.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/features/(user)/widgets/home/banner_slider.dart';
import 'package:paint_car/features/(user)/widgets/home/list_style_welcome.dart';
import 'package:paint_car/features/(user)/widgets/home/service_section.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key, required this.onRetry});
  final Future<void> Function() onRetry;
  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().getUserLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 24,
            children: [
              ListStyleWelcome(
                user: context.currentUser,
              ),
              const BannerSlider(),
              ServiceSection(
                onRetry: widget.onRetry,
                user: context.currentUser,
              ),
            ],
          ),
        ),
      ).paddingSymmetric(vertical: 24),
    );
  }
}
