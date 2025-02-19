import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';

import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_orders_cubit.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/currency_formatter.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class FinalUserCreateOrderPage extends StatefulWidget {
  final String workshopId;
  final String selectedUserCarId;
  final String? note;
  final List<String> carServices;
  final int totalPrice;

  static route({
    required String workshopId,
    required List<String> carServices,
    required String selectedUserCarId,
    String? note,
    required int totalPrice,
  }) =>
      MaterialPageRoute(
        builder: (_) => FinalUserCreateOrderPage(
          workshopId: workshopId,
          carServices: carServices,
          selectedUserCarId: selectedUserCarId,
          note: note,
          totalPrice: totalPrice,
        ),
      );

  const FinalUserCreateOrderPage({
    super.key,
    required this.workshopId,
    required this.carServices,
    required this.selectedUserCarId,
    this.note,
    required this.totalPrice,
  });

  @override
  State<FinalUserCreateOrderPage> createState() =>
      _FinalUserCreateOrderPageState();
}

class _FinalUserCreateOrderPageState extends State<FinalUserCreateOrderPage> {
  static const int limit = 50;
  late final CancelToken _cancelToken;

  final paymentMethodController = TextEditingController();
  var selectedPaymentMethodId;

  final formKey = GlobalKey<FormState>();

  void getPaymentMethods() {
    context.read<PaymentMethodCubit>().refresh(limit, _cancelToken);
  }

  @override
  void initState() {
    _cancelToken = CancelToken();
    getPaymentMethods();
    super.initState();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    paymentMethodController.dispose();
    super.dispose();
  }

  void _performAction() async {
    await context.read<UserOrdersCubit>().createOrder(
          widget.selectedUserCarId,
          selectedPaymentMethodId,
          widget.workshopId,
          widget.note,
          widget.carServices,
          _cancelToken,
        );
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      _performAction();
    }
  }

  Widget rowKeyValue(
    String key,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          text: key,
          extent: const Medium(),
        ),
        MainText(
          text: value,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
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
              message: "Transaction created successfully",
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
            "Create Transaction",
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                children: [
                  Material(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        rowKeyValue(
                          "Total Panel",
                          widget.carServices.length.toString(),
                        ),
                        rowKeyValue(
                          "Sub Total",
                          CurrencyFormatter.toRupiah(
                            widget.totalPrice.toDouble(),
                          ),
                        ),
                        rowKeyValue("Fee", "-"),
                        rowKeyValue("Total Price", "-"),
                      ],
                    ).paddingAll(),
                  ),
                  StateHandler<PaymentMethodCubit,
                      PaginationState<PaymentMethod>>(
                    onRetry: () => getPaymentMethods(),
                    onSuccess: (context, data, _) {
                      final paymentMethods = data.data;
                      LogService.i("Payment Methods: $paymentMethods");
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
                  MainElevatedButton(
                    onPressed: submitForm,
                    text: "Create",
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
