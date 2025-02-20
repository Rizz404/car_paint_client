import 'package:flutter/material.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/ui/extension/padding.dart';
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

  // Hanya untuk keperluan tampilan
  double getTotalPrice() {
    return carServices
        .where((service) => selectedServices.contains(service.id))
        .fold(0, (sum, service) => sum + int.parse(service.price));
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      headerBuilder: (isExpanded) {
        return Material(
          color: Theme.of(context).colorScheme.secondary,
          child: Row(
            children: [
              Checkbox(
                value: isSelectAll,
                onChanged: (value) => toggleAllServices(carServices),
              ),
              const MainText(
                text: 'Full Body (Select All)',
                customTextStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              MainText(
                text: '${selectedServices.length}/${carServices.length}',
              ),
              const SizedBox(width: 8),
              RotatedBox(
                quarterTurns: isExpanded ? 2 : 0,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ],
          ).paddingAll(8),
        );
      },
      expandedContent: Material(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            if (selectedServices.isNotEmpty) ...[
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const MainText(
                    text: 'Total Price:',
                    customTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  MainText(
                    text: CurrencyFormatter.toRupiah(getTotalPrice()),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ).paddingAll(),
            ],
            Divider(height: 1, color: Theme.of(context).colorScheme.surfaceDim),
            SizedBox(
              height: 200,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: carServices.length,
                itemBuilder: (context, index) {
                  final service = carServices[index];
                  return CheckboxListTile(
                    key: ValueKey(service.id),
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
            ),
          ],
        ),
      ),
    );
  }
}
