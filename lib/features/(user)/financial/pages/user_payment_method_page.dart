import 'package:flutter/material.dart';

class UserPaymentMethodPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserPaymentMethodPage());

  const UserPaymentMethodPage({super.key});

  @override
  State<UserPaymentMethodPage> createState() => _UserPaymentMethodPageState();
}

class _UserPaymentMethodPageState extends State<UserPaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
