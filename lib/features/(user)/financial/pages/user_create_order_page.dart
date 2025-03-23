import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';

import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/(user)/financial/pages/final_user_create_order_page.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UserCreateOrderPage extends StatefulWidget {
  final String workshopId;
  final List<String> carServices;
  final double totalPrice;
  final int totalAllServices;
  final VehicleData? vehicleData;
  final String carModelYearId;
  final String colorId;

  static route({
    required String workshopId,
    required List<String> carServices,
    required double totalPrice,
    required int totalAllServices,
    VehicleData? vehicleData,
    required String carModelYearId,
    required String colorId,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserCreateOrderPage(
          workshopId: workshopId,
          carServices: carServices,
          totalPrice: totalPrice,
          totalAllServices: totalAllServices,
          vehicleData: vehicleData,
          carModelYearId: carModelYearId,
          colorId: colorId,
        ),
      );

  const UserCreateOrderPage({
    super.key,
    required this.workshopId,
    required this.carServices,
    required this.totalPrice,
    required this.totalAllServices,
    this.vehicleData,
    required this.carModelYearId,
    required this.colorId,
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

  var selectedUserCarId;

  final formKey = GlobalKey<FormState>();

  void getUserCars() async {
    // await context.read<UserCarCubit>().refresh(limit, _cancelToken);
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
        // selectedUserCarId: selectedUserCarId!,
        note: noteController.text,
        totalPrice: widget.totalPrice,
        totalAllServices: widget.totalAllServices,
        carModelYearId: widget.carModelYearId,
        colorId: widget.colorId,
      ),
    );
  }

  void submitForm() {
    // if (selectedUserCarId == null) {
    //   SnackBarUtil.showSnackBar(
    //     context: context,
    //     message: "Please select user car",
    //     type: SnackBarType.error,
    //   );
    //   return;
    // }
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
            "Catatan Order",
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                children: [
                  // StateHandler<UserCarCubit, PaginationState<UserCar>>(
                  //   onRetry: () => getUserCars(),
                  //   onSuccess: (context, data, _) {
                  //     final userCars = data.data;
                  //     return Container(
                  //       child: DropdownMenu(
                  //         menuStyle: MenuStyle(
                  //           backgroundColor: WidgetStateProperty.all(
                  //             Theme.of(context).colorScheme.secondary,
                  //           ),
                  //         ),
                  //         width: double.infinity,
                  //         controller: userCarController,
                  //         enableFilter: true,
                  //         requestFocusOnTap: true,
                  //         initialSelection: selectedUserCarId ?? "",
                  //         onSelected: (value) {
                  //           setState(() {
                  //             selectedUserCarId = value;
                  //           });
                  //         },
                  //         label: const MainText(text: "Select User Car"),
                  //         dropdownMenuEntries: userCars.map((userCar) {
                  //           return DropdownMenuEntry(
                  //             labelWidget: Container(
                  //               margin: const EdgeInsets.symmetric(
                  //                 vertical: 8,
                  //               ), // gap di bawah tiap item
                  //               child: Row(
                  //                 spacing: 16,
                  //                 children: [
                  //                   ImageNetwork(
                  //                     src: userCar.carImages!.first!,
                  //                     width: 50,
                  //                     height: 50,
                  //                   ),
                  //                   MainText(
                  //                     text: userCar.licensePlate,
                  //                     customTextStyle: const TextStyle(
                  //                       fontWeight: FontWeight.w500,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             value: userCar.id,
                  //             label: userCar.licensePlate,
                  //           );
                  //         }).toList(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  MainTextField(
                    controller: noteController,
                    isEnabled: state is! BaseLoadingState,
                    maxLines: 3,
                    hintText: "Masukkan catatan",
                  ),
                  MainElevatedButton(
                    onPressed: submitForm,
                    text: "Selanjutnya",
                    isLoading: state is BaseLoadingState,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
