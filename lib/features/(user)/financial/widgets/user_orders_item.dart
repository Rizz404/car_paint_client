import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/utils/snack_bar.dart'; // pastikan sudah ada model CarService

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
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void cancelOrder() async {
    if (widget.order.id == null) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Order not found",
        type: SnackBarType.error,
      );
      return;
    }
    await context
        .read<UserOrdersCubit>()
        .cancelOrder(widget.order.id!, widget.cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // aksi ketika item di-tap, misalnya navigasi ke detail order
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Total Harga dan Tanggal Order
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(
                    text: 'Total: ${widget.order.subtotalPrice ?? "-"}',
                  ),
                  MainText(
                    text: _formatDate(widget.order.createdAt),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Catatan order (jika ada)
              if (widget.order.note != null && widget.order.note!.isNotEmpty)
                MainText(
                  text: widget.order.note!,
                ),
              const SizedBox(height: 8),
              // Status order
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        MainText(
                          text: widget.order.orderStatus?.name ?? '-',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<UserOrdersCubit, BaseState>(
                      listener: (context, state) {
                        handleFormListenerState(
                          context: context,
                          state: state,
                          onRetry: cancelOrder,
                          onSuccess: () {},
                        );
                      },
                      builder: (context, state) {
                        final status = widget.order.orderStatus;

                        return status == OrderStatus.COMPLETED ||
                                status == OrderStatus.CANCELLED
                            ? const SizedBox()
                            : MainElevatedButton(
                                onPressed: () {
                                  cancelOrder();
                                },
                                text: "Cancel Order",
                                isLoading: state is BaseLoadingState,
                                bgColor: widget.order.orderStatus ==
                                        OrderStatus.CANCELLED
                                    ? Theme.of(context)
                                        .colorScheme
                                        .errorContainer
                                    : Theme.of(context).colorScheme.error,
                                extent: const Small(),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
