import 'package:flutter/material.dart';

class UserWorkshopsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserWorkshopsPage());
  const UserWorkshopsPage({super.key});

  @override
  State<UserWorkshopsPage> createState() => _UserWorkshopsPageState();
}

class _UserWorkshopsPageState extends State<UserWorkshopsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("User Workshops Page"),
      ),
    );
  }
}
