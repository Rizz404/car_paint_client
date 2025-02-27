import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_text.dart';

void showStatusDescriptionBottomSheet(BuildContext context, WorkStatus status) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              text: status.toString().split('.').last,
              extent: const Large(),
            ),
            const SizedBox(height: 8),
            MainText(
              text:
                  workStatusDescriptions[status] ?? 'Deskripsi tidak tersedia.',
              maxLines: 3,
            ),
          ],
        ),
      );
    },
  );
}

class StatusTimeline extends StatelessWidget {
  final WorkStatus currentStatus;
  final double indicatorSize;
  final Color activeColor;
  final Color inactiveColor;
  final double lineWidth;

  const StatusTimeline({
    Key? key,
    required this.currentStatus,
    this.indicatorSize = 20.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.black,
    this.lineWidth = 2.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statuses = WorkStatus.values;
    final currentIndex = statuses.indexOf(currentStatus);

    return Column(
      children: List.generate(statuses.length, (index) {
        final isActive = index <= currentIndex;
        final status = statuses[index];

        return GestureDetector(
          onTap: () => showStatusDescriptionBottomSheet(context, status),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: indicatorSize,
                    height: indicatorSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? activeColor : inactiveColor,
                    ),
                  ),
                  if (index != statuses.length - 1)
                    Container(
                      width: lineWidth,
                      height: 40,
                      color: index < currentIndex ? activeColor : inactiveColor,
                    ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    status.toString().split('.').last,
                    style: TextStyle(
                      color: isActive ? activeColor : inactiveColor,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ).paddingSymmetric(horizontal: 16);
  }
}
