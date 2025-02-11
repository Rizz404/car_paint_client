import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:paint_car/ui/validator/number_validator.dart';

class UpsertCarModelYearsPage extends StatefulWidget {
  final CarModelYears? carModelYears;
  const UpsertCarModelYearsPage({super.key, this.carModelYears});
  static route({CarModelYears? carModelYears}) => MaterialPageRoute(
        builder: (context) =>
            UpsertCarModelYearsPage(carModelYears: carModelYears),
      );
  @override
  State<UpsertCarModelYearsPage> createState() =>
      _UpsertCarModelYearsPageState();
}

class _UpsertCarModelYearsPageState extends State<UpsertCarModelYearsPage> {
  late final CancelToken _cancelToken;
  final yearController = TextEditingController();
  final carBrandIdController = TextEditingController();
  var selectedCarModelId;
  final formKey = GlobalKey<FormState>();
  bool isUpdate = false;
  static const int limit = 50;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    getModel();
    setState(
      () {
        isUpdate = widget.carModelYears != null;
        selectedCarModelId = widget.carModelYears?.carModelId ?? "";
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUpdate) {
        yearController.text = widget.carModelYears!.year.toString();
      }
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    yearController.dispose();

    super.dispose();
  }

  void _performAction() {
    if (isUpdate) {
      context.read<CarModelYearsCubit>().updateModelYear(
            CarModelYears(
              id: widget.carModelYears?.id,
              carModelId: selectedCarModelId,
              year: int.parse(yearController.text),
            ),
            _cancelToken,
          );
    } else {
      context.read<CarModelYearsCubit>().saveModelYear(
            CarModelYears(
              carModelId: selectedCarModelId,
              year: int.parse(yearController.text),
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

  void getModel() {
    context.read<CarModelsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarModelYearsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message:
                  "Car modelYears ${isUpdate ? 'Updated' : 'Created'} successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            isUpdate ? "Update Car ModelYears" : "Create Car ModelYears",
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
                          ? "Update Car ModelYears"
                          : "Create Car ModelYears",
                      extent: const Large(),
                    ),
                    MainTextField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      hintText: "Enter model years name",
                      leadingIcon: const Icon(Icons.car_rental),
                      isEnabled: state is! BaseLoadingState,
                      validator: numberValidator,
                    ),
                    StateHandler<CarModelsCubit, PaginationState<CarModel>>(
                      onRetry: () => getModel(),
                      onSuccess: (context, data, _) {
                        final model = data.data;
                        return SizedBox(
                          width: double.infinity,
                          child: DropdownMenu(
                            width: double.infinity,
                            controller: carBrandIdController,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            initialSelection: selectedCarModelId ?? "",
                            onSelected: (value) {
                              setState(() {
                                selectedCarModelId = value;
                              });
                            },
                            label: const MainText(text: "Select Car Brand"),
                            dropdownMenuEntries: model.map((brand) {
                              return DropdownMenuEntry(
                                labelWidget: MainText(
                                  text: brand.name,
                                ),
                                value: brand.id,
                                label: brand.name,
                              );
                            }).toList(),
                          ),
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
