import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';

import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/pages/final_user_create_order_page.dart';
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
  final int totalPrice;
  static route({
    required String workshopId,
    required List<String> carServices,
    required int totalPrice,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserCreateOrderPage(
          workshopId: workshopId,
          carServices: carServices,
          totalPrice: totalPrice,
        ),
      );

  const UserCreateOrderPage({
    super.key,
    required this.workshopId,
    required this.carServices,
    required this.totalPrice,
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

  void getUserCars() {
    context.read<UserCarCubit>().refresh(limit, _cancelToken);
  }

  @override
  void initState() {
    _cancelToken = CancelToken();
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
    Navigator.of(context).push(
      FinalUserCreateOrderPage.route(
        workshopId: widget.workshopId,
        carServices: widget.carServices,
        selectedUserCarId: selectedUserCarId!,
        note: noteController.text,
        totalPrice: widget.totalPrice,
      ),
    );
  }

  void submitForm() {
    if (selectedUserCarId == null) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please select user car",
        type: SnackBarType.error,
      );
      return;
    }
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
