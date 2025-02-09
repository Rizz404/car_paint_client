import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
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
  var carBrandId = "";
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    setState(
      () {
        isUpdate = widget.carModel != null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carModel!.name;
        carBrandId = widget.carModel!.carBrandId;
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
              id: widget.carModel!.id,
              name: nameController.text,
              carBrandId: widget.carModel!.carBrandId,
              createdAt: widget.carModel!.createdAt,
              updatedAt: widget.carModel!.updatedAt,
            ),
          );
    } else {
      context.read<CarModelsCubit>().saveModel(
            CarModel(
              name: nameController.text,
              carBrandId: carBrandId,
            ),
          );
    }
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      _performAction();
    }
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
                    // get car brands
                    // jadiin dropdown

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
