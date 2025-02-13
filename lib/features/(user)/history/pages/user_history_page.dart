import 'package:flutter/material.dart';

class UserHistoryPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const UserHistoryPage());
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
