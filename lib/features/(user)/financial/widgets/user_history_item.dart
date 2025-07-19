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
  final bool enableWorkStatusEdit;
  final Function(WorkStatus)? onWorkStatusChanged;

  const UserHistoryItem({
    Key? key,
    required this.transactions,
    this.enableWorkStatusEdit = false,
    this.onWorkStatusChanged,
  }) : super(key: key);

  @override
  State<UserHistoryItem> createState() => _UserHistoryItemState();
}

class _UserHistoryItemState extends State<UserHistoryItem> {
  WorkStatus? selectedWorkStatus;
  bool isWorkStatusExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactions.order != null &&
        widget.transactions.order!.isNotEmpty) {
      selectedWorkStatus = widget.transactions.order!.first?.workStatus;
    }
  }

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

  // Fungsi untuk mendapatkan warna work status
  Color getWorkStatusColor(WorkStatus status) {
    switch (status) {
      case WorkStatus.QUEUED:
        return Colors.grey.shade600;
      case WorkStatus.INSPECTION:
        return Colors.orange.shade600;
      case WorkStatus.PUTTY:
        return Colors.brown.shade600;
      case WorkStatus.SURFACER:
        return Colors.indigo.shade600;
      case WorkStatus.APPLICATION_COLOR_BASE:
        return Colors.purple.shade600;
      case WorkStatus.APPLICATION_CLEAR_COAT:
        return Colors.blue.shade600;
      case WorkStatus.POLISHING:
        return Colors.cyan.shade600;
      case WorkStatus.FINAL_QC:
        return Colors.teal.shade600;
      case WorkStatus.COMPLETED:
        return Colors.green.shade600;
      case WorkStatus.CANCELLED:
        return Colors.red.shade600;
    }
  }

  // Fungsi untuk mendapatkan warna order status
  Color getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.DRAFT:
        return Colors.grey.shade600;
      case OrderStatus.CONFIRMED:
        return Colors.blue.shade600;
      case OrderStatus.PROCESSING:
        return Colors.orange.shade600;
      case OrderStatus.COMPLETED:
        return Colors.green.shade600;
      case OrderStatus.CANCELLED:
        return Colors.red.shade600;
    }
  }

  Widget buildPaymentStatusWidget(PaymentStatus status) {
    final Color statusColor = getPaymentStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border:
            Border.all(color: statusColor.withValues(alpha: 0.3), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPaymentStatusIcon(status),
            color: statusColor,
            size: 14,
          ),
          const SizedBox(width: 4),
          MainText(
            text: paymentStatusLabels[status] ?? status.name,
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

  // Widget untuk work status
  Widget buildWorkStatusWidget(WorkStatus status) {
    final Color statusColor = getWorkStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getWorkStatusIcon(status),
            color: statusColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          MainText(
            text: status.label,
            customTextStyle: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk order status
  Widget buildOrderStatusWidget(OrderStatus status) {
    final Color statusColor = getOrderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getOrderStatusIcon(status),
            color: statusColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          MainText(
            text: orderStatusLabels[status] ?? status.name,
            customTextStyle: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Widget WorkStatus Dropdown dengan semua data status
  Widget buildWorkStatusDropdown() {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan toggle expand/collapse
          InkWell(
            onTap: () {
              setState(() {
                isWorkStatusExpanded = !isWorkStatusExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isWorkStatusExpanded ? 0 : 12),
                  bottomRight: Radius.circular(isWorkStatusExpanded ? 0 : 12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timeline,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: MainText(
                      text: 'Status Pekerjaan',
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    isWorkStatusExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),

          // Current Status Display (always visible)
          if (selectedWorkStatus != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: getWorkStatusColor(selectedWorkStatus!)
                    .withValues(alpha: 0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MainText(
                        text: 'Status Saat Ini:',
                        customTextStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getWorkStatusColor(selectedWorkStatus!)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getWorkStatusIcon(selectedWorkStatus!),
                              color: getWorkStatusColor(selectedWorkStatus!),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            MainText(
                              text: selectedWorkStatus!.label,
                              customTextStyle: TextStyle(
                                color: getWorkStatusColor(selectedWorkStatus!),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: getWorkStatusColor(selectedWorkStatus!)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getWorkStatusColor(selectedWorkStatus!)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: getWorkStatusColor(selectedWorkStatus!)
                              .withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text: selectedWorkStatus!.description,
                            customTextStyle: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Expanded content
          if (isWorkStatusExpanded) ...[
            const Divider(height: 1),

            // Dropdown untuk edit status (jika diaktifkan)
            if (widget.enableWorkStatusEdit) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButtonFormField<WorkStatus>(
                  value: selectedWorkStatus,
                  decoration: InputDecoration(
                    labelText: 'Ubah Status Pekerjaan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  hint: const MainText(
                    text: 'Pilih status pekerjaan...',
                    customTextStyle: TextStyle(fontSize: 14),
                  ),
                  isExpanded: true,
                  items: WorkStatus.values.map((WorkStatus status) {
                    return DropdownMenuItem<WorkStatus>(
                      value: status,
                      child: _buildWorkStatusItem(status),
                    );
                  }).toList(),
                  onChanged: (WorkStatus? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedWorkStatus = newValue;
                      });
                      widget.onWorkStatusChanged?.call(newValue);
                    }
                  },
                ),
              ),
              const Divider(height: 1),
            ],

            // Semua status timeline
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainText(
                    text: 'Timeline Status Pekerjaan:',
                    customTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusTimeline(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Widget untuk item status dalam dropdown
  Widget _buildWorkStatusItem(WorkStatus status) {
    final Color statusColor = getWorkStatusColor(status);
    final bool isSelected = status == selectedWorkStatus;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? statusColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getWorkStatusIcon(status),
            color: statusColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: status.label,
                  customTextStyle: TextStyle(
                    color: statusColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                MainText(
                  text: status.description,
                  maxLines: 2,
                  customTextStyle: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget timeline status
  Widget _buildStatusTimeline() {
    final currentIndex = selectedWorkStatus != null
        ? WorkStatus.values.indexOf(selectedWorkStatus!)
        : -1;

    return Column(
      children: WorkStatus.values.asMap().entries.map((entry) {
        final index = entry.key;
        final status = entry.value;
        final isActive = index <= currentIndex;
        final isCurrent = status == selectedWorkStatus;
        final statusColor = getWorkStatusColor(status);

        return Row(
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCurrent
                        ? statusColor
                        : isActive
                            ? statusColor.withValues(alpha: 0.7)
                            : Colors.grey.shade300,
                    border: Border.all(
                      color: isCurrent
                          ? statusColor
                          : isActive
                              ? statusColor.withValues(alpha: 0.5)
                              : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _getWorkStatusIcon(status),
                    size: 12,
                    color: isCurrent || isActive
                        ? Colors.white
                        : Colors.grey.shade600,
                  ),
                ),
                if (index < WorkStatus.values.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: isActive
                        ? statusColor.withValues(alpha: 0.5)
                        : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Status info
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      text: status.label,
                      customTextStyle: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                        color: isCurrent
                            ? statusColor
                            : isActive
                                ? statusColor.withValues(alpha: 0.8)
                                : Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    MainText(
                      text: status.description,
                      maxLines: 2,
                      customTextStyle: TextStyle(
                        fontSize: 12,
                        color: isActive
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  IconData _getPaymentStatusIcon(PaymentStatus status) {
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

  // Icon untuk work status
  IconData _getWorkStatusIcon(WorkStatus status) {
    switch (status) {
      case WorkStatus.QUEUED:
        return Icons.queue;
      case WorkStatus.INSPECTION:
        return Icons.search;
      case WorkStatus.PUTTY:
        return Icons.construction;
      case WorkStatus.SURFACER:
        return Icons.format_paint;
      case WorkStatus.APPLICATION_COLOR_BASE:
        return Icons.palette;
      case WorkStatus.APPLICATION_CLEAR_COAT:
        return Icons.brush;
      case WorkStatus.POLISHING:
        return Icons.auto_fix_high;
      case WorkStatus.FINAL_QC:
        return Icons.checklist;
      case WorkStatus.COMPLETED:
        return Icons.task_alt;
      case WorkStatus.CANCELLED:
        return Icons.cancel;
    }
  }

  // Icon untuk order status
  IconData _getOrderStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.DRAFT:
        return Icons.edit_note;
      case OrderStatus.CONFIRMED:
        return Icons.check_circle;
      case OrderStatus.PROCESSING:
        return Icons.settings;
      case OrderStatus.COMPLETED:
        return Icons.done_all;
      case OrderStatus.CANCELLED:
        return Icons.cancel;
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
      spacing: 16,
      children: [
        SizedBox(
          width: 85,
          child: MainText(
            text: key,
            customTextStyle: keyStyle ??
                TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
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
      color: context.adaptiveCommonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
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

                // Tanggal dan Status Pembayaran
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: MainText(
                        text: _formatDate(transactions.createdAt),
                        customTextStyle: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    buildPaymentStatusWidget(transactions.paymentStatus),
                  ],
                ),

                // Status Order dan Work
                if (order.orderStatus != null || order.workStatus != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (order.orderStatus != null) ...[
                        buildOrderStatusWidget(order.orderStatus!),
                        const SizedBox(width: 8),
                      ],
                      if (order.workStatus != null)
                        buildWorkStatusWidget(order.workStatus!),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // WorkStatus Dropdown dengan timeline
          if (selectedWorkStatus != null) buildWorkStatusDropdown(),

          const Divider(height: 1),

          // Informasi Utama
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.store,
                      size: 24,
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
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
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
                      text: "Panel (${order.carServices!.length})",
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
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.carServices!.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
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
                              double.parse(carService.price),
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
                    double.parse(transactions.totalPrice),
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
