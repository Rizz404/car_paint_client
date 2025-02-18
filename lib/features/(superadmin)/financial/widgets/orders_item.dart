// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/orders_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class OrdersItem extends StatefulWidget {
  final Orders order;
  const OrdersItem({
    super.key,
    required this.order,
  });

  @override
  State<OrdersItem> createState() => _OrdersItemState();
}

class _OrdersItemState extends State<OrdersItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<OrdersCubit, BaseState>(
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
                        text: widget.order.subtotalPrice ?? 'default value',
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
