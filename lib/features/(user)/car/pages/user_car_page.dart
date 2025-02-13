import 'package:flutter/material.dart';

class UserCarPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const UserCarPage());
  const UserCarPage({super.key});

  @override
  State<UserCarPage> createState() => _UserCarPageState();
}

class _UserCarPageState extends State<UserCarPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
