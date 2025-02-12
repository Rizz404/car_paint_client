import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UpsertCarColorsPage extends StatefulWidget {
  final CarColor? carColor;
  const UpsertCarColorsPage({super.key, this.carColor});
  static route({CarColor? carColor}) => MaterialPageRoute(
        builder: (context) => UpsertCarColorsPage(carColor: carColor),
      );
  @override
  State<UpsertCarColorsPage> createState() => _UpsertCarColorsPageState();
}

class _UpsertCarColorsPageState extends State<UpsertCarColorsPage> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  late final CancelToken _cancelToken;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    setState(
      () {
        isUpdate = widget.carColor != null;
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        nameController.text = widget.carColor!.name;
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarColorsCubit>().updateColor(
            CarColor(
              id: widget.carColor?.id!,
              name: nameController.text,
            ),
            _cancelToken,
          );
    } else {
      context.read<CarColorsCubit>().saveColor(
            CarColor(
              name: nameController.text,
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
    return BlocConsumer<CarColorsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car color ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car Colors" : "Create Car Colors",
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
                      text: isUpdate ? "Update Car Color" : "Create Car Color",
                      extent: const Large(),
                    ),
                    MainTextField(
                      controller: nameController,
                      hintText: "Enter color name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Color name cannot be empty";
                        }
                        return null;
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
