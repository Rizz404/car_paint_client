import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      iconSize: 28,
      elevation: 0.0,
      onTap: onItemTapped,
      // selectedItemColor: CustomColors.secondaryBlue,
      // unselectedItemColor: CustomColors.tertiaryGray,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
          tooltip: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Transaksi',
          tooltip: 'Transaksi',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.message),
        //   label: 'Pesan',
        //   tooltip: 'Pesan',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
          tooltip: 'Profil',
        ),
      ],
    );
  }
}
