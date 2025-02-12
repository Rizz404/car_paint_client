// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/e_ticket.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class ETicketsItem extends StatefulWidget {
  final ETicket ticket;
  const ETicketsItem({
    super.key,
    required this.ticket,
  });

  @override
  State<ETicketsItem> createState() => _ETicketsItemState();
}

class _ETicketsItemState extends State<ETicketsItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlocBuilder<ETicketCubit, BaseState>(
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
                        text: widget.ticket.ticketNumber.toString(),
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
