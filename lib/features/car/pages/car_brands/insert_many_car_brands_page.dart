import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/widgets/image_car_action.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class InsertManyCarBrandsPage extends StatefulWidget {
  const InsertManyCarBrandsPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const InsertManyCarBrandsPage(),
      );

  @override
  State<InsertManyCarBrandsPage> createState() =>
      _InsertManyCarBrandsPageState();
}

class _InsertManyCarBrandsPageState extends State<InsertManyCarBrandsPage> {
  final List<BrandFormData> _brands = [BrandFormData()];
  final _formKey = GlobalKey<FormState>();

  void _addBrand() => setState(() => _brands.add(BrandFormData()));

  void _removeBrand(int index) => setState(() => _brands.removeAt(index));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final validBrands = _brands.where((b) => b.isValid).toList();
    final invalidBrands = _brands.where((b) => !b.isValid).toList();

    if (invalidBrands.isNotEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please fill all fields and select image for each brand",
        type: SnackBarType.error,
      );
      return;
    }

    context.read<CarBrandsCubit>().saveManyBrands(
          validBrands.map((b) => b.toCarBrand()).toList(),
          validBrands.map((b) => b.image!).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarBrandsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: _submit,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Multiple brands created successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar("Create Multiple Brands"),
          body: Form(
            key: _formKey,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _brands.length,
              itemBuilder: (ctx, i) => BrandFormItem(
                key: ValueKey(i),
                data: _brands[i],
                onRemove: () => _removeBrand(i),
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
                onPressed: _addBrand,
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

class BrandFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  File? image;
  bool imageError = false;

  bool get isValid =>
      nameController.text.isNotEmpty &&
      countryController.text.isNotEmpty &&
      image != null;

  CarBrand toCarBrand() => CarBrand(
        name: nameController.text,
        country: countryController.text,
      );

  void dispose() {
    nameController.dispose();
    countryController.dispose();
  }
}

class BrandFormItem extends StatefulWidget {
  final BrandFormData data;
  final ValueChanged<BrandFormData>? onChanged;
  final VoidCallback? onRemove;
  final int index;
  final bool isEnabled;

  const BrandFormItem({
    super.key,
    required this.data,
    this.onChanged,
    this.onRemove,
    required this.index,
    this.isEnabled = true,
  });

  @override
  State<BrandFormItem> createState() => _BrandFormItemState();
}

class _BrandFormItemState extends State<BrandFormItem> {
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        if (!mounted) return;

        setState(() {
          widget.data.image = File(pickedFile.path);
          widget.data.imageError = false;
        });
        widget.onChanged?.call(widget.data);
      }
    } on PlatformException catch (e) {
      LogService.e("Error picking image: $e");
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Something went wrong picking image",
        type: SnackBarType.error,
      );
    }
  }

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
                  text: "Brand #${widget.index}",
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
            ImageCarAction(
              selectedImage: widget.data.image,
              onPickImage: _pickImage,
              logoUrl: null,
            ),
            const SizedBox(height: 16),
            MainTextField(
              controller: widget.data.nameController,
              hintText: "Enter brand name",
              leadingIcon: const Icon(Icons.car_rental),
              isEnabled: widget.isEnabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Brand name cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            MainTextField(
              controller: widget.data.countryController,
              hintText: "Enter country",
              leadingIcon: const Icon(Icons.flag),
              isEnabled: widget.isEnabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Country cannot be empty";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
