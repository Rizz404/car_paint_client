import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/features/home/pages/settings_page.dart';
import 'package:paint_car/features/home/widgets/bottom_nav_bar.dart';
import 'package:paint_car/features/home/widgets/left_drawer.dart';
import 'package:paint_car/features/home/pages/user_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.initState();
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const MainText(text: "Home Page"),
          if (context.userRole == UserRole.ADMIN)
            const MainText(text: "Welcome Admin"),
          if (context.userRole == UserRole.USER)
            const MainText(text: "Welcome User"),
          if (context.userRole == UserRole.SUPER_ADMIN)
            const MainText(text: "Welcome Super Admin"),
        ],
      ),
    );
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
