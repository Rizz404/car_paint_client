import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/widgets/home/home_user.dart';
import 'package:paint_car/features/home/pages/settings_page.dart';
import 'package:paint_car/features/home/pages/user_page.dart';
import 'package:paint_car/features/home/widgets/bottom_nav_bar.dart';
import 'package:paint_car/features/home/widgets/home_admin.dart';
import 'package:paint_car/features/home/widgets/left_drawer.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final CancelToken _cancelToken;

  @override
  void initState() {
    _cancelToken = CancelToken();
    getUserCars();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  Future<void> getUserCars() async {
    context.read<UserCarCubit>().getUserCars(1, _cancelToken);
  }

  Widget _buildHomePage() {
    final role = context.userRole;
    switch (role) {
      case UserRole.ADMIN:
        return const HomeAdmin();
      case UserRole.USER:
        return HomeUser(
          onRetry: getUserCars,
        );
      case UserRole.SUPER_ADMIN:
        return const MainText(text: "Welcome Super Admin");
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _title() {
    switch (_selectedIndex) {
      case 0:
        return "Home";
      case 1:
        return "Settings";
      case 2:
        return "User";
      default:
        return "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    drawerBasedOnRole() {
      if (context.userRole == UserRole.SUPER_ADMIN ||
          context.userRole == UserRole.USER) {
        return LeftDrawer();
      } else {
        null;
      }
    }

    return Scaffold(
      appBar: mainAppBar(_title()),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      drawer: drawerBasedOnRole(),
      body: [
        _buildHomePage(),
        const SettingsPage(),
        const UserPage(),
      ][_selectedIndex],
    );
  }
}
