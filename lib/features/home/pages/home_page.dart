import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/enums/user_role.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/data/utils/user_extension.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/user_car_page.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_workshops_page.dart';
import 'package:paint_car/features/home/pages/settings_page.dart';
import 'package:paint_car/features/home/widgets/bottom_nav_bar.dart';
import 'package:paint_car/features/home/widgets/left_drawer.dart';
import 'package:paint_car/features/home/pages/user_page.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

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
    navigateBasedOnUserCar();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  navigateBasedOnUserCar() async {
    await context.read<UserCarCubit>().getUserCars(1, _cancelToken);
  }

  Widget _buildHomePage() {
    final role = context.userRole;
    return SingleChildScrollView(
      child: Column(
        children: [
          const MainText(text: "Home Page"),
          if (role == UserRole.ADMIN) const MainText(text: "Welcome Admin"),
          if (role == UserRole.USER) const MainText(text: "Welcome User"),
          if (role == UserRole.SUPER_ADMIN)
            const MainText(text: "Welcome Super Admin"),
          if (role == UserRole.USER) buttonOrder(),
        ],
      ),
    );
  }

  buttonOrder() {
    return BlocBuilder<UserCarCubit, BaseState>(
      builder: (context, state) {
        if (state is BaseSuccessState<PaginationState<UserCar>>) {
          return MainElevatedButton(
            onPressed: () {
              if (state.data.data.isEmpty) {
                SnackBarUtil.showSnackBar(
                  context: context,
                  message: "Harus input mobil dulu untuk order",
                  type: SnackBarType.warning,
                );
                Navigator.of(context).push(UserCarPage.route());
                return;
              }
              Navigator.of(context).push(UserWorkshopsPage.route());
            },
            text: "Order Disini",
          );
        }
        return const MainText(text: "Loading...");
      },
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
