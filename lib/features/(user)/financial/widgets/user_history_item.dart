import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/transactions.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
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
  final Map<PaymentStatus, String> statusLabels = {
    PaymentStatus.SUCCESS: 'Berhasil',
    PaymentStatus.PENDING: 'Menunggu',
    PaymentStatus.FAILED: 'Gagal',
    PaymentStatus.EXPIRED: 'Kedaluwarsa',
    PaymentStatus.REFUNDED: 'Dikembalikan',
  };

  Color getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Colors.green.shade700;
      case PaymentStatus.PENDING:
        return Colors.amber.shade700;
      case PaymentStatus.FAILED:
        return Colors.red.shade700;
      case PaymentStatus.EXPIRED:
        return Colors.grey.shade700;
      case PaymentStatus.REFUNDED:
        return Colors.blue.shade700;
    }
  }

  Widget buildPaymentStatusWidget(PaymentStatus status) {
    final Color statusColor = getPaymentStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          MainText(
            text: statusLabels[status] ?? status.name,
            customTextStyle: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.SUCCESS:
        return Icons.check_circle_outline;
      case PaymentStatus.PENDING:
        return Icons.hourglass_empty;
      case PaymentStatus.FAILED:
        return Icons.error_outline;
      case PaymentStatus.EXPIRED:
        return Icons.timer_off_outlined;
      case PaymentStatus.REFUNDED:
        return Icons.replay;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('E, dd MMM yyyy • HH:mm').format(date);
  }

  Widget _keyValue(
    String key,
    String value, {
    TextStyle? keyStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 85,
          child: MainText(
            text: key,
            customTextStyle: keyStyle ??
                TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
        ),
        Expanded(
          child: MainText(
            text: value,
            customTextStyle: valueStyle ??
                TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            maxLines: 3,
          ),
        ),
      ],
    );
  }

  String _getPaymentMethodName(String? name) {
    if (name == null) return '-';

    // Capitalize with proper spacing for payment methods
    switch (name.toUpperCase()) {
      case 'SHOPEEPAY':
        return ' ShopeePay';
      case 'GOPAY':
        return 'GoPay';
      case 'BCA':
        return 'BCA Virtual Account';
      case 'BNI':
        return 'BNI Virtual Account';
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.transactions;
    final theme = Theme.of(context);
    final expandTheme = theme.copyWith(dividerColor: Colors.transparent);

    // Validasi order
    if (transactions.order == null || transactions.order!.isEmpty) {
      return const SizedBox();
    }

    final order = transactions.order!.first!;
    final hasWorkshop = order.workshop != null;
    final hasServices =
        order.carServices != null && order.carServices!.isNotEmpty;
    final hasNote = order.note != null && order.note!.isNotEmpty;
    final hasETicket = order.eTicket != null && order.eTicket!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      elevation: 2,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan tanggal dan status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Invoice ID
                MainText(
                  text: 'Invoice #${transactions.id.substring(0, 8)}',
                  extent: const Medium(),
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // Tanggal dan Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: MainText(
                        text: _formatDate(transactions.createdAt),
                        customTextStyle: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                    buildPaymentStatusWidget(transactions.paymentStatus),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Informasi Utama
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: CustomColors.aliceBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _keyValue(
                  'Pembayaran ',
                  _getPaymentMethodName(transactions.paymentMethod?.name),
                ),
                if (hasNote) ...[
                  const SizedBox(height: 8),
                  _keyValue('Catatan', order.note!),
                ],
                if (hasETicket) ...[
                  const SizedBox(height: 8),
                  _keyValue(
                    'E-Ticket',
                    'No. ${order.eTicket!.first!.ticketNumber}',
                    valueStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Courier',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Workshop Info
          if (hasWorkshop) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CustomColors.aliceBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 24,
                      color: CustomColors.secondaryRed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainText(
                          text: order.workshop!.name,
                          customTextStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        MainText(
                          text: order.workshop!.address,
                          extent: const ExtraSmall(),
                          maxLines: 2,
                          customTextStyle: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // Services
          if (hasServices) ...[
            Theme(
              data: expandTheme,
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                title: Row(
                  children: [
                    Icon(
                      Icons.build_outlined,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    MainText(
                      text: "Layanan (${order.carServices!.length})",
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: CustomColors.aliceBlue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.carServices!.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      itemBuilder: (context, i) {
                        final carService = order.carServices![i];
                        return ListTile(
                          dense: true,
                          title: MainText(
                            text: carService!.name,
                            extent: const Medium(),
                            customTextStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: MainText(
                            text: CurrencyFormatter.toRupiah(
                              int.parse(carService.price),
                            ),
                            customTextStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
          ],

          // Total
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: CustomColors.aliceBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: MainText(
                    text: 'Total Pembayaran',
                    extent: Medium(),
                    customTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                MainText(
                  text: CurrencyFormatter.toRupiah(
                    int.parse(transactions.totalPrice),
                  ),
                  textAlign: TextAlign.end,
                  extent: const Medium(),
                  customTextStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
