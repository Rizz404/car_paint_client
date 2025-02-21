import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/widgets/status_timeline.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
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
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: theme,
                  child: ExpansionTile(
                    title: const MainText(
                      text: "Work Status",
                      customTextStyle: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    children: [
                      Divider(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        thickness: 1,
                      ),
                      StatusTimeline(
                        currentStatus: WorkStatus.FINAL_QC,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainText(
                      text: 'Total: ${widget.order.subtotalPrice ?? "-"}',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    MainText(
                      text: _formatDate(widget.order.createdAt),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            if (widget.order.note != null && widget.order.note!.isNotEmpty)
              MainText(
                text: "Note: ${widget.order.note!}",
              ).paddingSymmetric(horizontal: 16),
            Row(
              spacing: 4,
              children: [
                MainText(
                  text:
                      "Order Status: ${widget.order.orderStatus?.name ?? '-'}",
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<UserOrdersCubit, BaseState>(
              listener: (context, state) {
                handleFormListenerState(
                  context: context,
                  state: state,
                  onRetry: cancelOrder,
                  onSuccess: () {
                    SnackBarUtil.showSnackBar(
                      context: context,
                      message: "Order cancelled",
                      type: SnackBarType.success,
                    );
                  },
                );
              },
              builder: (context, state) {
                final status = widget.order.orderStatus;

                return status == OrderStatus.COMPLETED ||
                        status == OrderStatus.CANCELLED
                    ? const SizedBox()
                    : MainElevatedButton(
                        height: 40,
                        borderRadius: 4,
                        onPressed: () {
                          cancelOrder();
                        },
                        text: "Cancel Order",
                        isLoading: state is BaseLoadingState,
                        bgColor:
                            widget.order.orderStatus == OrderStatus.CANCELLED
                                ? Theme.of(context).colorScheme.errorContainer
                                : Theme.of(context).colorScheme.error,
                        extent: const Small(),
                      ).paddingSymmetric(horizontal: 16);
              },
            ),
          ],
        ).paddingOnly(bottom: 16),
      ),
    );
  }
}
