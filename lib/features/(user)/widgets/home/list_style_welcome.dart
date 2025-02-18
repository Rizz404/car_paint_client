import 'package:flutter/material.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/features/(user)/car/pages/user_car_page.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class ListStyleWelcome extends StatelessWidget {
  const ListStyleWelcome({super.key, this.user});
  final UserWithProfile? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2), // x,y
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: ListTile(
        title: const MainText(
          text: "Welcome",
          customTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: MainText(text: "${user?.email}"),
        leading: const Icon(Icons.person_outline),
        trailing: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            Navigator.of(context).push(UserCarPage.route());
          },
        ),
      ),
    );
  }
}
