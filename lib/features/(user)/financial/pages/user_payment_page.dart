import 'package:flutter/material.dart';

class UserPaymentPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const UserPaymentPage());

  const UserPaymentPage({super.key});

  @override
  State<UserPaymentPage> createState() => _UserPaymentPageState();
}

class _UserPaymentPageState extends State<UserPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
