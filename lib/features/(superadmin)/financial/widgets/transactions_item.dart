// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/transactions_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class TransactionsItem extends StatefulWidget {
  final Transactions transactions;
  const TransactionsItem({
    super.key,
    required this.transactions,
  });

  @override
  State<TransactionsItem> createState() => _TransactionsItemState();
}

class _TransactionsItemState extends State<TransactionsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<TransactionsCubit, BaseState>(
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
                        text: widget.transactions.paymentStatus.toString(),
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
