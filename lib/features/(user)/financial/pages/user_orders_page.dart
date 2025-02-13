import 'package:flutter/material.dart';

class UserOrdersPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const UserOrdersPage());
  const UserOrdersPage({super.key});

  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
