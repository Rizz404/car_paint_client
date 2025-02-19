import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
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
  PaymentMethod? selectedPaymentMethod;

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
    if (selectedPaymentMethod == null) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please select payment method",
        type: SnackBarType.error,
      );
      return;
    }
    await context.read<UserOrdersCubit>().createOrder(
          widget.selectedUserCarId,
          selectedPaymentMethod!.id!,
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

  Map<PaymentMethodType, List<PaymentMethod>> _groupPaymentMethods(
      List<PaymentMethod> methods) {
    final map = <PaymentMethodType, List<PaymentMethod>>{};
    for (var method in methods) {
      if (method.type != null) {
        map.putIfAbsent(method.type!, () => []).add(method);
      }
    }
    final orderedKeys = PaymentMethodType.values
        .where((type) => map.containsKey(type))
        .toList();
    return Map.fromEntries(orderedKeys.map((key) => MapEntry(key, map[key]!)));
  }

  void _showPaymentMethodModal(
      BuildContext context, List<PaymentMethod> methods) {
    final grouped = _groupPaymentMethods(methods);

    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: MainText(text: 'Select Payment Method', extent: Large()),
            ),
            ...grouped.entries.map((entry) => _buildPaymentMethodGroup(entry)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodGroup(
      MapEntry<PaymentMethodType, List<PaymentMethod>> entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            entry.key.toString().split('.').last.replaceAll('_', ' '),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...entry.value.map((pm) => ListTile(
              title: Text(pm.name),
              subtitle: Text('Fee: ${pm.fee}'),
              leading: pm.logoUrl != null
                  ? ImageNetwork(
                      src: pm.logoUrl!,
                      width: 40,
                      height: 40,
                    )
                  : null,
              onTap: () {
                setState(() {
                  selectedPaymentMethod = pm;
                  paymentMethodController.text =
                      pm.name; // Update controller text
                });
                Navigator.pop(context);
              },
            )),
      ],
    );
  }

  int _parseFee(String fee) {
    try {
      return int.parse(fee.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      return 0;
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
                              widget.totalPrice.toDouble()),
                        ),
                        rowKeyValue(
                          "Fee",
                          selectedPaymentMethod != null
                              ? CurrencyFormatter.toRupiah(
                                  _parseFee(selectedPaymentMethod!.fee!)
                                      .toDouble())
                              : "-",
                        ),
                        rowKeyValue(
                          "Total Price",
                          selectedPaymentMethod != null
                              ? CurrencyFormatter.toRupiah((widget.totalPrice +
                                      _parseFee(selectedPaymentMethod!.fee!))
                                  .toDouble())
                              : "-",
                        ),
                      ],
                    ).paddingAll(),
                  ),
                  StateHandler<PaymentMethodCubit,
                      PaginationState<PaymentMethod>>(
                    onRetry: () => getPaymentMethods(),
                    onSuccess: (context, data, _) {
                      final paymentMethods = data.data;

                      return GestureDetector(
                        onTap: () =>
                            _showPaymentMethodModal(context, paymentMethods),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: paymentMethodController,
                            decoration: InputDecoration(
                              labelText: 'Payment Method',
                              hintText: selectedPaymentMethod != null
                                  ? '${selectedPaymentMethod!.name} (${CurrencyFormatter.toRupiah(_parseFee(selectedPaymentMethod!.fee!).toDouble())})'
                                  : 'Select payment method',
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                            validator: (value) {
                              if (selectedPaymentMethod == null) {
                                return 'Please select payment method';
                              }
                              return null;
                            },
                          ),
                        ),
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
