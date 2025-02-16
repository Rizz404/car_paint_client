import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/orders.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/ui/shared/main_text.dart'; // pastikan sudah ada model CarService

class UserOrdersItem extends StatelessWidget {
  final Orders order;
  const UserOrdersItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
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
                    text: 'Total: ${order.totalPrice ?? "-"}',
                  ),
                  MainText(
                    text: _formatDate(order.createdAt),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Catatan order (jika ada)
              if (order.note != null && order.note!.isNotEmpty)
                MainText(
                  text: order.note!,
                ),
              const SizedBox(height: 8),
              // Status order
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  MainText(
                    text: order.orderStatus?.name ?? '-',
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
