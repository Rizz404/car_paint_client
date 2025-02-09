import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UpsertCarModelsPage extends StatefulWidget {
  final CarModel? carModel;
  const UpsertCarModelsPage({super.key, this.carModel});
  static route({CarModel? carModel}) => MaterialPageRoute(
        builder: (context) => UpsertCarModelsPage(carModel: carModel),
      );
  @override
  State<UpsertCarModelsPage> createState() => _UpsertCarModelsPageState();
}

class _UpsertCarModelsPageState extends State<UpsertCarModelsPage> {
  final nameController = TextEditingController();
  final carBrandIdController = TextEditingController();
  var selectedCarBrandId;
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  static const int limit = 50;

  @override
  void initState() {
    super.initState();
    getBrands();
    setState(
      () {
        isUpdate = widget.carModel != null;
        selectedCarBrandId = widget.carModel?.carBrandId ?? "";
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carModel!.name;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();

    super.dispose();
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarModelsCubit>().updateModel(
            CarModel(
              id: widget.carModel?.id,
              name: nameController.text,
              carBrandId: selectedCarBrandId,
            ),
          );
    } else {
      context.read<CarModelsCubit>().saveModel(
            CarModel(
              name: nameController.text,
              carBrandId: selectedCarBrandId,
            ),
          );
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      _performAction();
    }
  }

  void getBrands() {
    context.read<CarBrandsCubit>().refresh(limit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarModelsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car model ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car Models" : "Create Car Models",
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    MainText(
                      text: isUpdate ? "Update Car Model" : "Create Car Model",
                      extent: const Large(),
                    ),
                    MainTextField(
                      controller: nameController,
                      hintText: "Enter model name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Model name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    StateHandler<CarBrandsCubit, PaginationState<CarBrand>>(
                      onRetry: () => getBrands(),
                      onSuccess: (context, data, _) {
                        final brands = data.data;
                        return DropdownMenu(
                          controller: carBrandIdController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedCarBrandId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedCarBrandId = value;
                            });
                          },
                          label: const MainText(text: "Select Car Brand"),
                          dropdownMenuEntries: brands.map((brand) {
                            return DropdownMenuEntry(
                              leadingIcon: ImageNetwork(
                                src: brand.logo!,
                                width: 60,
                                height: 60,
                              ),
                              labelWidget: MainText(
                                text: brand.name,
                              ),
                              value: brand.id,
                              label: brand.name,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    MainElevatedButton(
                      onPressed: submitForm,
                      text: isUpdate ? "Update" : "Create",
                      isLoading: state is BaseLoadingState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
