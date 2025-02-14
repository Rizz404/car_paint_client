import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/expandable_card.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class CheckboxServices extends StatelessWidget {
  final bool isSelectAll;
  final List<CarService> carServices;
  final List<String> selectedServices;
  final void Function(String) toggleService;
  final void Function(List<CarService>) toggleAllServices;

  const CheckboxServices({
    Key? key,
    required this.isSelectAll,
    required this.carServices,
    required this.selectedServices,
    required this.toggleService,
    required this.toggleAllServices,
  }) : super(key: key);

  // Menghitung total harga dari layanan yang terpilih
  double getTotalPrice() {
    return carServices
        .where((service) => selectedServices.contains(service.id))
        .fold(0, (sum, service) => sum + int.parse(service.price));
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      headerBuilder: (isExpanded) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Checkbox(
                value: isSelectAll,
                onChanged: (value) => toggleAllServices(carServices),
              ),
              const MainText(
                text: 'Full Body (Select All)',
              ),
              const Spacer(),
              // Menampilkan jumlah layanan terpilih
              MainText(
                text: '${selectedServices.length}/${carServices.length}',
              ),
              const SizedBox(width: 8),
              // Icon arrow yang berotasi sesuai status expand
              RotatedBox(
                quarterTurns: isExpanded ? 2 : 0,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ),
        );
      },
      expandedContent: Column(
        children: [
          if (selectedServices.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MainText(
                    text: 'Total Price:',
                  ),
                  MainText(
                    text: CurrencyFormatter.toRupiah(getTotalPrice()),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: carServices.length,
            itemBuilder: (context, index) {
              final service = carServices[index];
              return CheckboxListTile(
                title: MainText(
                  text: service.name,
                ),
                subtitle: MainText(
                  text: CurrencyFormatter.toRupiah(
                    int.parse(service.price),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                value: selectedServices.contains(service.id),
                onChanged: (value) => toggleService(service.id!),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
