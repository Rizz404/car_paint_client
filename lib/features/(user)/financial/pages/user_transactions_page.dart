import 'package:flutter/material.dart';

class UserTransactionsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserTransactionsPage());

  const UserTransactionsPage({super.key});

  @override
  State<UserTransactionsPage> createState() => _UserTransactionsPageState();
}

class _UserTransactionsPageState extends State<UserTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
