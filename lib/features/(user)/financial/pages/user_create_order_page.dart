import 'package:flutter/material.dart';

class UserCreateOrderPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserCreateOrderPage());

  const UserCreateOrderPage({super.key});

  @override
  State<UserCreateOrderPage> createState() => _UserCreateOrderPageState();
}

class _UserCreateOrderPageState extends State<UserCreateOrderPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
