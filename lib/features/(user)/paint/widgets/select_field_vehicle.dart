import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class SelectFieldVehicle extends StatefulWidget {
  const SelectFieldVehicle({
    super.key,
    required this.field,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  final String field;
  final String value;
  final List<String> options;
  final Function(String) onSelected;

  @override
  State<SelectFieldVehicle> createState() => _SelectFieldVehicleState();
}

class _SelectFieldVehicleState extends State<SelectFieldVehicle> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showOptions(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              extent: const Medium(),
              text: widget.field,
              color: CustomColors.tertiaryGray,
            ),
            Row(
              children: [
                MainText(
                  extent: const Medium(),
                  text: widget.value,
                  color: CustomColors.tertiaryGray,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: CustomColors.tertiaryGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: MainText(
                text: widget.field,
                extent: const Large(),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = option == widget.value;

                  return ListTile(
                    title: MainText(
                      text: option,
                      extent: const Medium(),
                      color: isSelected
                          ? CustomColors.black
                          : CustomColors.black.withAlpha(50),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: CustomColors.black.withAlpha(50),
                          )
                        : null,
                    onTap: () {
                      widget.onSelected(option);
                      Navigator.pop(context);
                    },
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
