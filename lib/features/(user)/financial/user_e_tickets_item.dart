// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/e_ticket.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/user_e_tickets_cubit.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserETicketsItem extends StatefulWidget {
  final ETicket ticket;
  const UserETicketsItem({
    super.key,
    required this.ticket,
  });

  @override
  State<UserETicketsItem> createState() => _UserETicketsItemState();
}

class _UserETicketsItemState extends State<UserETicketsItem> {
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<UserETicketsCubit, BaseState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan Ticket Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainText(
                      text: "E-Ticket #${widget.ticket.ticketNumber}",
                      customTextStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    MainText(
                      text: _formatDate(widget.ticket.createdAt),
                      extent: const Medium(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                // TODO setelah benerin fromMap uncomment
                // const SizedBox(height: 12),

                // Divider(
                //   height: 1,
                //   thickness: 1,
                //   color: Theme.of(context).colorScheme.surfaceDim,
                // ),
                // const SizedBox(height: 12),

                // if (widget.ticket.order?.userCar != null) ...[
                //   MainText(
                //     text: "Vehicle Information",
                //     customTextStyle: const TextStyle(
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   const SizedBox(height: 8),
                //   MainText(
                //     text:
                //         "${widget.ticket.order!.userCar!.carModelYearColor.carModelYear.carModel.carBrand.name} ${widget.ticket.order!.userCar!.carModelYearColor.carModelYear.carModel.name}",
                //   ),
                //   const SizedBox(height: 12),
                // ],

                // if (widget.ticket.order?.workshop != null) ...[
                //   MainText(
                //     text: "Workshop Information",
                //     customTextStyle: const TextStyle(
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   const SizedBox(height: 8),
                //   MainText(
                //     text: widget.ticket.order!.workshop!.name,
                //   ),
                // ],
              ],
            );
          },
        ),
      ),
    );
  }
}
