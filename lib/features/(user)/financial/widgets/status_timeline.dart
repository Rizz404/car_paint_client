import 'package:flutter/material.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';

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
        // Tentukan apakah status ini aktif (sudah tercapai) atau belum.
        final isActive = index <= currentIndex;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom indikator dan garis
            Column(
              children: [
                // Lingkaran indikator
                Container(
                  width: indicatorSize,
                  height: indicatorSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                ),
                // Jika bukan item terakhir, tampilkan garis vertikal
                if (index != statuses.length - 1)
                  Container(
                    width: lineWidth,
                    height: 40, // atur tinggi garis sesuai kebutuhan
                    color: index < currentIndex ? activeColor : inactiveColor,
                  ),
              ],
            ),
            const SizedBox(width: 8),
            // Label status
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  statuses[index].toString().split('.').last,
                  style: TextStyle(
                    color: isActive ? activeColor : inactiveColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
