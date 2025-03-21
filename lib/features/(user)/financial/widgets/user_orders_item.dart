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

  Widget _buildStatusBadge(OrderStatus? status) {
    Color bgColor;
    Color textColor = Colors.white;
    String statusText = status?.name ?? 'UNKNOWN';

    switch (status) {
      case OrderStatus.COMPLETED:
        bgColor = Colors.green;
        statusText = 'Selesai';
        break;
      case OrderStatus.CANCELLED:
        bgColor = Colors.red;
        textColor = Colors.white;
        statusText = 'Dibatalkan';
        break;
      case OrderStatus.DRAFT:
        bgColor = Colors.amber;
        textColor = Colors.black87;
        statusText = 'Draft';
        break;
      default:
        bgColor = Colors.blue;
        statusText = status?.name ?? 'UNKNOWN';
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
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _viewOrderDetails,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      _buildStatusBadge(order.orderStatus),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MainText(
                        text: 'Tanggal: ${_formatDate(order.createdAt)}',
                        customTextStyle: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      MainText(
                        text:
                            'Total: ${widget.order.subtotalPrice != null ? CurrencyFormatter.toRupiah(int.parse(widget.order.subtotalPrice!)) : '-'}',
                        customTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
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
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MainText(
                      text: order.note!,
                      maxLines: 2,
                      customTextStyle: TextStyle(
                        fontSize: 14,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            Theme(
              data: expansionTheme,
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: const MainText(
                  text: "Status Pengerjaan",
                  customTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
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
                    bgColor: theme.colorScheme.error,
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
