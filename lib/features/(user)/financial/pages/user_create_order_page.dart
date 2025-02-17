import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';

import 'package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/pages/user_transactions_page.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UserCreateOrderPage extends StatefulWidget {
  final String workshopId;
  final List<String> carServices;
  static route({
    required String workshopId,
    required List<String> carServices,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserCreateOrderPage(
          workshopId: workshopId,
          carServices: carServices,
        ),
      );

  const UserCreateOrderPage({
    super.key,
    required this.workshopId,
    required this.carServices,
  });

  @override
  State<UserCreateOrderPage> createState() => _UserCreateOrderPageState();
}

class _UserCreateOrderPageState extends State<UserCreateOrderPage> {
  static const int limit = 50;
  late final CancelToken _cancelToken;

  final paymentMethodController = TextEditingController();
  final userCarController = TextEditingController();
  final noteController = TextEditingController();

  var selectedPaymentMethodId;
  var selectedUserCarId;

  final formKey = GlobalKey<FormState>();

  void getPaymentMethods() {
    context.read<PaymentMethodCubit>().refresh(limit, _cancelToken);
  }

  void getUserCars() {
    context.read<UserCarCubit>().refresh(limit, _cancelToken);
  }

  @override
  void initState() {
    _cancelToken = CancelToken();
    getPaymentMethods();
    getUserCars();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    paymentMethodController.dispose();
    userCarController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void _performAction() async {
    // TODO: create order
    await context.read<UserOrdersCubit>().createOrder(
          selectedUserCarId,
          selectedPaymentMethodId,
          widget.workshopId,
          noteController.text.isEmpty ? null : noteController.text,
          widget.carServices,
          _cancelToken,
        );
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      _performAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserOrdersCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Order created successfully",
              type: SnackBarType.success,
            );
            Navigator.of(context).pushAndRemoveUntil(
              HomePage.route(),
              (_) => false,
            );
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            "Create Order",
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    const MainText(
                      text: "Create Order",
                      extent: const Large(),
                    ),
                    StateHandler<UserCarCubit, PaginationState<UserCar>>(
                      onRetry: () => getUserCars(),
                      onSuccess: (context, data, _) {
                        final userCars = data.data;
                        return DropdownMenu(
                          width: double.infinity,
                          controller: userCarController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedUserCarId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedUserCarId = value;
                            });
                          },
                          label: const MainText(text: "Select User Car"),
                          dropdownMenuEntries: userCars.map((userCar) {
                            return DropdownMenuEntry(
                              labelWidget: MainText(
                                text: userCar.licensePlate,
                              ),
                              leadingIcon: ImageNetwork(
                                src: userCar.carImages!.first!,
                                width: 50,
                                height: 50,
                              ),
                              value: userCar.id,
                              label: userCar.licensePlate,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    StateHandler<PaymentMethodCubit,
                        PaginationState<PaymentMethod>>(
                      onRetry: () => getPaymentMethods(),
                      onSuccess: (context, data, _) {
                        final paymentMethods = data.data;
                        return DropdownMenu(
                          width: double.infinity,
                          controller: paymentMethodController,
                          enableFilter: true,
                          requestFocusOnTap: true,
                          initialSelection: selectedPaymentMethodId ?? "",
                          onSelected: (value) {
                            setState(() {
                              selectedPaymentMethodId = value;
                            });
                          },
                          label: const MainText(text: "Select Payment Method"),
                          dropdownMenuEntries:
                              paymentMethods.map((paymentMethod) {
                            return DropdownMenuEntry(
                              labelWidget: MainText(
                                text: paymentMethod.name,
                              ),
                              value: paymentMethod.id,
                              label: paymentMethod.name,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    MainTextField(
                      controller: noteController,
                      hintText: "Enter note",
                      leadingIcon: const Icon(Icons.note),
                      isEnabled: state is! BaseLoadingState,
                    ),
                    MainElevatedButton(
                      onPressed: submitForm,
                      text: "Create",
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
