import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/widgets/status_timeline.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UserOrdersItem extends StatefulWidget {
  final Orders order;
  final CancelToken cancelToken;

  const UserOrdersItem({
    Key? key,
    required this.order,
    required this.cancelToken,
  }) : super(key: key);

  @override
  State<UserOrdersItem> createState() => _UserOrdersItemState();
}

class _UserOrdersItemState extends State<UserOrdersItem> {
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _cancelOrder() async {
    if (widget.order.id == null) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Order tidak ditemukan",
        type: SnackBarType.error,
      );
      return;
    }

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembatalan'),
        content: const Text('Anda yakin ingin membatalkan pesanan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      await context
          .read<UserOrdersCubit>()
          .cancelOrder(widget.order.id!, widget.cancelToken);
    }
  }

  void _viewOrderDetails() {}

  Widget _buildOrderStatusBadge(OrderStatus? status) {
    Color bgColor;
    Color textColor = Colors.white;
    String statusText = orderStatusLabels[status] ?? 'TIDAK DIKETAHUI';

    switch (status) {
      case OrderStatus.COMPLETED:
        bgColor = Colors.green;
        break;
      case OrderStatus.CANCELLED:
        bgColor = Colors.red;
        break;
      case OrderStatus.DRAFT:
        bgColor = Colors.amber;
        textColor = Colors.black87;
        break;
      case OrderStatus.CONFIRMED:
        bgColor = Colors.blue;
        break;
      case OrderStatus.PROCESSING:
        bgColor = Colors.orange;
        break;
      default:
        bgColor = Colors.grey;
        statusText = 'TIDAK DIKETAHUI';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWorkStatusIndicator(WorkStatus? workStatus) {
    if (workStatus == null) return const SizedBox.shrink();

    Color indicatorColor;
    IconData iconData;

    switch (workStatus) {
      case WorkStatus.QUEUED:
        indicatorColor = Colors.grey;
        iconData = Icons.hourglass_empty;
        break;
      case WorkStatus.INSPECTION:
        indicatorColor = Colors.blue;
        iconData = Icons.search;
        break;
      case WorkStatus.PUTTY:
        indicatorColor = Colors.brown;
        iconData = Icons.build;
        break;
      case WorkStatus.SURFACER:
        indicatorColor = Colors.purple;
        iconData = Icons.layers;
        break;
      case WorkStatus.APPLICATION_COLOR_BASE:
        indicatorColor = Colors.indigo;
        iconData = Icons.color_lens;
        break;
      case WorkStatus.APPLICATION_CLEAR_COAT:
        indicatorColor = Colors.teal;
        iconData = Icons.auto_fix_high;
        break;
      case WorkStatus.POLISHING:
        indicatorColor = Colors.yellow;
        iconData = Icons.star;
        break;
      case WorkStatus.FINAL_QC:
        indicatorColor = Colors.orange;
        iconData = Icons.fact_check;
        break;
      case WorkStatus.COMPLETED:
        indicatorColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case WorkStatus.CANCELLED:
        indicatorColor = Colors.red;
        iconData = Icons.cancel;
        break;
      default:
        indicatorColor = Colors.grey;
        iconData = Icons.help;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: indicatorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: indicatorColor.withOpacity(0.3)),
          ),
          child: Icon(
            iconData,
            color: indicatorColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: MainText(
            text: workStatus.label,
            customTextStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: indicatorColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusBadge(PaymentStatus? paymentStatus) {
    if (paymentStatus == null) return const SizedBox.shrink();

    Color bgColor;
    Color textColor = Colors.white;
    String statusText = paymentStatusLabels[paymentStatus] ?? 'TIDAK DIKETAHUI';

    switch (paymentStatus) {
      case PaymentStatus.SUCCESS:
        bgColor = Colors.green;
        break;
      case PaymentStatus.PENDING:
        bgColor = Colors.orange;
        break;
      case PaymentStatus.FAILED:
        bgColor = Colors.red;
        break;
      case PaymentStatus.EXPIRED:
        bgColor = Colors.grey;
        break;
      case PaymentStatus.REFUNDED:
        bgColor = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expansionTheme = theme.copyWith(dividerColor: Colors.transparent);
    final order = widget.order;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _viewOrderDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: MainText(
                          text: 'Order #${order.id?.substring(0, 8) ?? "-"}',
                          customTextStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _buildOrderStatusBadge(order.orderStatus),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Work Status Indicator
                  _buildWorkStatusIndicator(order.workStatus),
                  const SizedBox(height: 8),

                  // Date and Total Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainText(
                            text: 'Tanggal: ${_formatDate(order.createdAt)}',
                            customTextStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (order.updatedAt != null)
                            MainText(
                              text:
                                  'Diperbarui: ${_formatDate(order.updatedAt)}',
                              customTextStyle: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MainText(
                            text:
                                'Total: ${widget.order.subtotalPrice != null ? CurrencyFormatter.toRupiah(double.parse(widget.order.subtotalPrice!)) : '-'}',
                            customTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Payment Status (uncomment jika ada data payment status)
                          // _buildPaymentStatusBadge(order.paymentStatus),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Work Status Description
            if (order.workStatus != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          MainText(
                            text: "Status Pengerjaan",
                            customTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      MainText(
                        text: order.workStatus!.description,
                        customTextStyle: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Note Section
            if (order.note != null && order.note!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      text: "Catatan:",
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MainText(
                      text: order.note!,
                      maxLines: 2,
                      customTextStyle: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

            // Status Timeline Expansion
            Theme(
              data: expansionTheme,
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Row(
                  children: [
                    Icon(
                      Icons.timeline,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const MainText(
                      text: "Timeline Pengerjaan",
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                childrenPadding: const EdgeInsets.only(bottom: 16.0),
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  StatusTimeline(
                    currentStatus: order.workStatus ?? WorkStatus.QUEUED,
                    activeColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),

            // Action Button
            BlocConsumer<UserOrdersCubit, BaseState>(
              listener: (context, state) {
                handleFormListenerState(
                  context: context,
                  state: state,
                  onRetry: _cancelOrder,
                  onSuccess: () {
                    SnackBarUtil.showSnackBar(
                      context: context,
                      message: "Pesanan berhasil dibatalkan",
                      type: SnackBarType.success,
                    );
                  },
                );
              },
              builder: (context, state) {
                final status = order.orderStatus;

                if (status == OrderStatus.COMPLETED ||
                    status == OrderStatus.CANCELLED) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MainElevatedButton(
                    height: 44,
                    borderRadius: 8,
                    onPressed: state is BaseLoadingState ? null : _cancelOrder,
                    text: "Batalkan Pesanan",
                    isLoading: state is BaseLoadingState,
                    extent: const Small(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
