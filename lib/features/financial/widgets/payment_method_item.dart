// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class PaymentMethodItem extends StatefulWidget {
  final PaymentMethod order;
  const PaymentMethodItem({
    super.key,
    required this.order,
  });

  @override
  State<PaymentMethodItem> createState() => _PaymentMethodItemState();
}

class _PaymentMethodItemState extends State<PaymentMethodItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<PaymentMethodCubit, BaseState>(
        builder: (context, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: SizedBox(
                      height: 100,
                      child: MainText(
                        text: widget.order.name,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
