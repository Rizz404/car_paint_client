import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class InsertManyCarColorsPage extends StatefulWidget {
  const InsertManyCarColorsPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const InsertManyCarColorsPage(),
      );

  @override
  State<InsertManyCarColorsPage> createState() =>
      _InsertManyCarColorsPageState();
}

class _InsertManyCarColorsPageState extends State<InsertManyCarColorsPage> {
  final List<ColorFormData> _colors = [ColorFormData()];
  final _formKey = GlobalKey<FormState>();

  void _addColor() => setState(() => _colors.add(ColorFormData()));

  void _removeColor(int index) => setState(() => _colors.removeAt(index));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final invalidColors = _colors.where((b) => !b.isValid).toList();

    if (invalidColors.isNotEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please fill all fields for each color",
        type: SnackBarType.error,
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarColorsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: _submit,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Multiple colors created successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar("Create Multiple Colors"),
          body: Form(
            key: _formKey,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _colors.length,
              itemBuilder: (ctx, i) => ColorFormItem(
                key: ValueKey(i),
                data: _colors[i],
                onRemove: () => _removeColor(i),
                index: i + 1,
                isEnabled: state is! BaseLoadingState,
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'add',
                onPressed: _addColor,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'save',
                onPressed: state is! BaseLoadingState ? _submit : null,
                child: state is BaseLoadingState
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.save),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ColorFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool get isValid =>
      nameController.text.isNotEmpty && priceController.text.isNotEmpty;

  CarColor toCarColor() => CarColor(
        name: nameController.text,
      );

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class ColorFormItem extends StatefulWidget {
  final ColorFormData data;
  final ValueChanged<ColorFormData>? onChanged;
  final VoidCallback? onRemove;
  final int index;
  final bool isEnabled;

  const ColorFormItem({
    super.key,
    required this.data,
    this.onChanged,
    this.onRemove,
    required this.index,
    this.isEnabled = true,
  });

  @override
  State<ColorFormItem> createState() => _ColorFormItemState();
}

class _ColorFormItemState extends State<ColorFormItem> {
  @override
  void dispose() {
    widget.data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MainText(
                  text: "Color #${widget.index}",
                  extent: const Medium(),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.isEnabled ? widget.onRemove : null,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 16),
            MainTextField(
              controller: widget.data.nameController,
              hintText: "Enter color name",
              leadingIcon: const Icon(Icons.car_rental),
              isEnabled: widget.isEnabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Color name cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // get car brands
            // jadiin dropdown
          ],
        ),
      ),
    );
  }
}
