import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UpsertCarModelYearColor extends StatefulWidget {
  final CarModelYearColor? carModelYearColor;
  const UpsertCarModelYearColor({
    super.key,
    this.carModelYearColor,
  });
  static route({CarModelYearColor? carModelYearColor}) => MaterialPageRoute(
        builder: (context) => UpsertCarModelYearColor(
          carModelYearColor: carModelYearColor,
        ),
      );
  @override
  State<UpsertCarModelYearColor> createState() =>
      UpsertCarModelYearColorState();
}

class UpsertCarModelYearColorState extends State<UpsertCarModelYearColor> {
  final carModelYearIdController = TextEditingController();
  final colorIdController = TextEditingController();
  var selectedCarModelYearId;
  var selectedColorId;
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  static const int limit = 50;
  late final CancelToken _cancelToken;

  @override
  void initState() {
    _cancelToken = CancelToken();
    super.initState();
    getCarModelYears();
    getColors();
    setState(
      () {
        isUpdate = widget.carModelYearColor != null;
        selectedCarModelYearId = widget.carModelYearColor?.carModelYearId;
        selectedColorId = widget.carModelYearColor?.colorId;
      },
    );
  }

  @override
  void dispose() {
    carModelYearIdController.dispose();
    colorIdController.dispose();
    super.dispose();
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarModelYearColorCubit>().updateModel(
            CarModelYearColor(
              id: widget.carModelYearColor?.id,
              carModelYearId: selectedCarModelYearId,
              colorId: selectedColorId,
            ),
            _cancelToken,
          );
    } else {
      context.read<CarModelYearColorCubit>().saveModel(
            CarModelYearColor(
              carModelYearId: selectedCarModelYearId,
              colorId: selectedColorId,
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

  void getCarModelYears() {
    context.read<CarModelYearsCubit>().refresh(limit);
  }

  void getColors() {
    context.read<CarColorsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarModelYearColorCubit, BaseState>(
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
            isUpdate
                ? "Update Car ModelYearColor"
                : "Create Car ModelYearColor",
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
                    StateHandler<CarModelYearsCubit,
                        PaginationState<CarModelYears>>(
                      onRetry: () => getCarModelYears(),
                      onSuccess: (context, data, _) {
                        final modelYears = data.data;
                        return DropdownMenu(
                          width: double.infinity,
                          controller: carModelYearIdController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedCarModelYearId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedCarModelYearId = value;
                            });
                          },
                          label: const MainText(text: "Select Car Model Year"),
                          dropdownMenuEntries: modelYears.map((modelYear) {
                            return DropdownMenuEntry(
                              labelWidget: MainText(
                                text: modelYear.year.toString(),
                              ),
                              value: modelYear.id,
                              label: modelYear.year.toString(),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    StateHandler<CarColorsCubit, PaginationState<CarColor>>(
                      onRetry: () => getColors(),
                      onSuccess: (context, data, _) {
                        final colors = data.data;
                        return DropdownMenu(
                          width: double.infinity,
                          controller: colorIdController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedColorId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedColorId = value;
                            });
                          },
                          label: const MainText(text: "Select Color"),
                          dropdownMenuEntries: colors.map((color) {
                            return DropdownMenuEntry(
                              labelWidget: MainText(
                                text: color.name,
                              ),
                              value: color.id,
                              label: color.name,
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
