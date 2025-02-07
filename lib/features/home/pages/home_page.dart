import 'package:flutter/material.dart';
import 'package:paint_car/features/home/pages/settings_page.dart';
import 'package:paint_car/features/home/widgets/bottom_nav_bar.dart';
import 'package:paint_car/features/home/widgets/left_drawer.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
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
    return const SingleChildScrollView(
      child: const Column(
        children: [
          MainText(text: "Home Page"),
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
      default:
        return "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(_title()),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      drawer: LeftDrawer(),
      body: [
        _buildHomePage(),
        const SettingsPage(),
      ][_selectedIndex],
    );
  }
}
