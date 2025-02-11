import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:paint_car/ui/validator/number_validator.dart';

class UpsertCarServicesPage extends StatefulWidget {
  final CarService? carService;
  const UpsertCarServicesPage({super.key, this.carService});
  static route({CarService? carService}) => MaterialPageRoute(
        builder: (context) => UpsertCarServicesPage(carService: carService),
      );
  @override
  State<UpsertCarServicesPage> createState() => _UpsertCarServicesPageState();
}

class _UpsertCarServicesPageState extends State<UpsertCarServicesPage> {
  late final CancelToken _cancelToken;
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  var selectedCarServiceId;
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    setState(
      () {
        isUpdate = widget.carService != null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carService!.name;
        priceController.text = widget.carService!.price.toString();
      }
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    nameController.dispose();
    priceController.dispose();

    super.dispose();
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarServicesCubit>().updateService(
            CarService(
              id: widget.carService?.id!,
              name: nameController.text,
              price: priceController.text,
            ),
            _cancelToken,
          );
    } else {
      context.read<CarServicesCubit>().saveService(
            CarService(
              name: nameController.text,
              price: priceController.text,
            ),
            _cancelToken,
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
    return BlocConsumer<CarServicesCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car service ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car Services" : "Create Car Services",
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
                      text: isUpdate
                          ? "Update Car Service"
                          : "Create Car Service",
                      extent: const Large(),
                    ),
                    MainTextField(
                      controller: nameController,
                      hintText: "Enter service name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Service name cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: priceController,
                      hintText: "Enter service price",
                      leadingIcon: const Icon(Icons.money),
                      isEnabled: state is! BaseLoadingState,
                      validator: numberValidator,
                      keyboardType: TextInputType.number,
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
