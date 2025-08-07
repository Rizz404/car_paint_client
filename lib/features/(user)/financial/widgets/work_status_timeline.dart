import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class WorkStatusTimeline extends StatelessWidget {
  final WorkStatus? currentStatus;
  final bool showDescription;
  final bool isCompact;
  const WorkStatusTimeline({
    Key? key,
    this.currentStatus,
    this.showDescription = true,
    this.isCompact = false,
  }) : super(key: key);
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

  bool isStatusCompleted(WorkStatus status, WorkStatus? currentStatus) {
    if (currentStatus == null) return false;
    if (currentStatus == WorkStatus.CANCELLED) return false;
    final statusIndex = WorkStatus.values.indexOf(status);
    final currentIndex = WorkStatus.values.indexOf(currentStatus);
    return statusIndex < currentIndex || status == currentStatus;
  }

  bool isCurrentStatus(WorkStatus status, WorkStatus? currentStatus) {
    return status == currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validStatuses = WorkStatus.values
        .where((status) => status != WorkStatus.CANCELLED)
        .toList();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
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
                  size: isCompact ? 18 : 20,
                ),
                const SizedBox(width: 8),
                MainText(
                  text: 'Progress Pekerjaan',
                  customTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isCompact ? 14 : 16,
                  ),
                ),
                if (currentStatus != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getWorkStatusColor(currentStatus!)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MainText(
                      text: currentStatus!.label,
                      customTextStyle: TextStyle(
                        color: getWorkStatusColor(currentStatus!),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(isCompact ? 12 : 16),
            child: Column(
              children: validStatuses.asMap().entries.map((entry) {
                final index = entry.key;
                final status = entry.value;
                final isLast = index == validStatuses.length - 1;
                final isCompleted = isStatusCompleted(status, currentStatus);
                final isCurrent = isCurrentStatus(status, currentStatus);
                final statusColor = getWorkStatusColor(status);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: isCompact ? 36 : 40,
                          height: isCompact ? 36 : 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? statusColor
                                : statusColor.withValues(alpha: 0.1),
                            border: Border.all(
                              color: isCompleted
                                  ? statusColor
                                  : statusColor.withValues(alpha: 0.3),
                              width: isCurrent ? 3 : 2,
                            ),
                          ),
                          child: Icon(
                            getWorkStatusIcon(status),
                            color: isCompleted
                                ? Colors.white
                                : statusColor.withValues(alpha: 0.7),
                            size: isCompact ? 18 : 20,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: isCompact ? 40 : 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  isCompleted
                                      ? statusColor
                                      : statusColor.withValues(alpha: 0.3),
                                  index < validStatuses.length - 2 &&
                                          isStatusCompleted(
                                              validStatuses[index + 1],
                                              currentStatus)
                                      ? getWorkStatusColor(
                                          validStatuses[index + 1])
                                      : statusColor.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : (isCompact ? 12 : 16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: MainText(
                                    text: status.label,
                                    customTextStyle: TextStyle(
                                      fontWeight: isCurrent
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      fontSize: isCompact ? 13 : 15,
                                      color: isCompleted
                                          ? statusColor
                                          : theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                                if (isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: MainText(
                                      text: 'Saat Ini',
                                      customTextStyle: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if (showDescription && !isCompact) ...[
                              const SizedBox(height: 4),
                              MainText(
                                text: status.description,
                                maxLines: 3,
                                customTextStyle: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                            if (isCurrent && showDescription) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: MainText(
                                        text:
                                            'Pekerjaan sedang dalam tahap ini',
                                        customTextStyle: TextStyle(
                                          fontSize: 11,
                                          color: statusColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MainText(
                      text: 'Progress Keseluruhan',
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    MainText(
                      text: currentStatus != null
                          ? '${((validStatuses.indexOf(currentStatus!) + 1) / validStatuses.length * 100).toInt()}%'
                          : '0%',
                      customTextStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: currentStatus != null
                            ? getWorkStatusColor(currentStatus!)
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: currentStatus != null
                        ? (validStatuses.indexOf(currentStatus!) + 1) /
                            validStatuses.length
                        : 0,
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      currentStatus != null
                          ? getWorkStatusColor(currentStatus!)
                          : theme.colorScheme.primary,
                    ),
                    minHeight: 8,
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
