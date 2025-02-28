import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserHistoryItem extends StatefulWidget {
  final Transactions transactions;
  const UserHistoryItem({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<UserHistoryItem> createState() => _UserHistoryItemState();
}

class _UserHistoryItemState extends State<UserHistoryItem> {
  Color getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Colors.green;
      case PaymentStatus.PENDING:
        return Colors.amber;
      case PaymentStatus.FAILED:
        return Colors.red;
      case PaymentStatus.EXPIRED:
        return Colors.grey;
      case PaymentStatus.REFUNDED:
        return Colors.blue;
    }
  }

  Widget buildPaymentStatusWidget(PaymentStatus status) {
    final Color statusColor = getPaymentStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(51),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: MainText(
        text: status.name,
        customTextStyle: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  keyValue(
    String key,
    String value, {
    TextStyle? keyStyle,
    TextStyle? valueStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainText(
          text: key,
          customTextStyle:
              keyStyle ?? const TextStyle(fontWeight: FontWeight.w600),
        ),
        MainText(
          text: value,
          customTextStyle: valueStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Transactions transactions = widget.transactions;
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    // ! kalo order nya null gausah masuk sini, soalnya ini kan history page
    if (transactions.order == null || transactions.order!.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Column(
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(
                    text: _formatDate(transactions.createdAt),
                    extent: const Medium(),
                    customTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  buildPaymentStatusWidget(transactions.paymentStatus),
                ],
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              keyValue(
                'Payment: ',
                transactions.paymentMethod?.name ?? "-",
              ),
              if (transactions.order!.first!.note!.isNotEmpty)
                keyValue(
                  'Note: ',
                  transactions.order!.first!.note!,
                ),
              if (transactions.order!.first!.eTicket!.isNotEmpty)
                keyValue(
                  'E-Ticket: ',
                  transactions.order!.first!.eTicket!.first!.ticketNumber
                      .toString(),
                ),
            ],
          ).paddingSymmetric(horizontal: 16),
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.surfaceDim,
          ).paddingSymmetric(horizontal: 16),
          if (transactions.order!.first!.workshop != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainText(
                  text: "Workshop",
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                MainText(
                  text: transactions.order!.first!.workshop!.name,
                ),
                MainText(
                  text: transactions.order!.first!.workshop!.address,
                  extent: const ExtraSmall(),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.surfaceDim,
          ).paddingSymmetric(horizontal: 16),
          Theme(
            data: theme,
            child: ExpansionTile(
              title: const MainText(
                text: "Services",
                customTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final carService =
                        transactions.order!.first!.carServices![i];
                    return ListTile(
                      title: MainText(
                        text: carService!.name,
                        extent: const Medium(),
                      ),
                      subtitle: MainText(
                        text: CurrencyFormatter.toRupiah(
                          int.parse(carService.price),
                        ),
                      ),
                    );
                  },
                  itemCount: transactions.order!.first!.carServices!.length,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Theme.of(context).colorScheme.surfaceDim,
          ).paddingSymmetric(horizontal: 16),
          Row(
            children: [
              const Expanded(
                child: MainText(
                  text: 'Total:',
                  extent: Medium(),
                ),
              ),
              Expanded(
                child: MainText(
                  text: CurrencyFormatter.toRupiah(
                    int.parse(transactions.totalPrice),
                  ),
                  textAlign: TextAlign.end,
                  extent: const Medium(),
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ).paddingSymmetric(vertical: 16),
    );
  }
}
