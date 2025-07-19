import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class WorkStatusDropdown extends StatefulWidget {
  final WorkStatus? currentWorkStatus;
  final Function(WorkStatus) onWorkStatusChanged;
  final bool enabled;

  const WorkStatusDropdown({
    Key? key,
    this.currentWorkStatus,
    required this.onWorkStatusChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<WorkStatusDropdown> createState() => _WorkStatusDropdownState();
}

class _WorkStatusDropdownState extends State<WorkStatusDropdown> {
  WorkStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentWorkStatus;
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

  // Icon untuk work status
  IconData getWorkStatusIcon(WorkStatus status) {
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

  Widget buildWorkStatusItem(WorkStatus status, {bool isSelected = false}) {
    final Color statusColor = getWorkStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? statusColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: isSelected
            ? Border.all(color: statusColor.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Icon(
            getWorkStatusIcon(status),
            color: statusColor,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: status.label,
                  customTextStyle: TextStyle(
                    color: statusColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                MainText(
                  text: status.description,
                  maxLines: 2,
                  customTextStyle: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
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
                const MainText(
                  text: 'Status Pekerjaan',
                  customTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Current Status Display
          if (selectedStatus != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    getWorkStatusColor(selectedStatus!).withValues(alpha: 0.05),
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
                          color: getWorkStatusColor(selectedStatus!)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              getWorkStatusIcon(selectedStatus!),
                              color: getWorkStatusColor(selectedStatus!),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            MainText(
                              text: selectedStatus!.label,
                              customTextStyle: TextStyle(
                                color: getWorkStatusColor(selectedStatus!),
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
                      color: getWorkStatusColor(selectedStatus!)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: getWorkStatusColor(selectedStatus!)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: getWorkStatusColor(selectedStatus!)
                              .withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: MainText(
                            text: selectedStatus!.description,
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

          // Dropdown
          if (widget.enabled) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<WorkStatus>(
                value: selectedStatus,
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
                    child: buildWorkStatusItem(
                      status,
                      isSelected: status == selectedStatus,
                    ),
                  );
                }).toList(),
                onChanged: (WorkStatus? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedStatus = newValue;
                    });
                    widget.onWorkStatusChanged(newValue);
                  }
                },
              ),
            ),
          ],

          // All Status List (Read-only view)
          if (!widget.enabled) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MainText(
                    text: 'Semua Status Pekerjaan:',
                    customTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...WorkStatus.values.map((status) {
                    final isCurrentStatus = status == selectedStatus;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: buildWorkStatusItem(
                        status,
                        isSelected: isCurrentStatus,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
