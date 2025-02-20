import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/enums/financial_status.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';

import 'package:paint_car/features/(superadmin)/financial/cubit/payment_method_cubit.dart';
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
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class FinalUserCreateOrderPage extends StatefulWidget {
  final String workshopId;
  final String selectedUserCarId;
  final String? note;
  final List<String> carServices;
  final int totalPrice;
  final int totalAllServices;

  static route({
    required String workshopId,
    required List<String> carServices,
    required String selectedUserCarId,
    String? note,
    required int totalPrice,
    required int totalAllServices,
  }) =>
      MaterialPageRoute(
        builder: (_) => FinalUserCreateOrderPage(
          workshopId: workshopId,
          carServices: carServices,
          selectedUserCarId: selectedUserCarId,
          note: note,
          totalPrice: totalPrice,
          totalAllServices: totalAllServices,
        ),
      );

  const FinalUserCreateOrderPage({
    super.key,
    required this.workshopId,
    required this.carServices,
    required this.selectedUserCarId,
    this.note,
    required this.totalPrice,
    required this.totalAllServices,
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

  Widget rowKeyValue(String key, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          text: key,
          extent: const Medium(),
          customTextStyle: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        MainText(
          text: value,
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Map<PaymentMethodType, List<PaymentMethod>> _groupPaymentMethods(
    List<PaymentMethod> methods,
  ) {
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

  int _parseFee(String fee) {
    try {
      return int.parse(fee.replaceAll(RegExp(r'[^0-9]'), ''));
    } catch (e) {
      return 0;
    }
  }

  Widget _buildPaymentMethodSections(List<PaymentMethod> methods) {
    final grouped = _groupPaymentMethods(methods);

    return Column(
      children: grouped.entries.map((entry) {
        return ExpansionTile(
          title: MainText(
            text: entry.key.toString().split('.').last.replaceAll('_', ' '),
            customTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
            extent: const Medium(),
          ),
          children:
              entry.value.map((pm) => _buildPaymentMethodTile(pm)).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod pm) {
    final isSelected = selectedPaymentMethod?.id == pm.id;

    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.secondary.withValues(
                alpha: 0.7,
              ),
      borderOnForeground: false,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        leading: pm.logoUrl != null
            ? ImageNetwork(
                src: pm.logoUrl!,
                width: 60,
                height: 60,
              )
            : const ImageNetwork(
                src:
                    "https://i.pinimg.com/736x/b6/53/c1/b653c128eb1017e5983388c6fc3e9bf1.jpg",
                width: 60,
                height: 60,
              ),
        title: MainText(
          text: pm.name,
          maxLines: 2,
          extent: const Medium(),
        ),
        subtitle: MainText(
          text:
              'Fee: ${CurrencyFormatter.toRupiah(_parseFee(pm.fee!).toDouble())}',
          color: Theme.of(context).colorScheme.primary,
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () {
          setState(() {
            selectedPaymentMethod = pm;
          });
        },
      ),
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
                          "${widget.carServices.length.toString()}/${widget.totalAllServices.toString()}",
                          isBold: true,
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surfaceDim,
                          thickness: 1,
                        ),
                        rowKeyValue(
                          "Sub Total",
                          CurrencyFormatter.toRupiah(
                            widget.totalPrice.toDouble(),
                          ),
                        ),
                        rowKeyValue(
                          "Fee",
                          selectedPaymentMethod != null
                              ? CurrencyFormatter.toRupiah(
                                  _parseFee(selectedPaymentMethod!.fee!)
                                      .toDouble(),
                                )
                              : "-",
                        ),
                        Divider(
                          color: Theme.of(context).colorScheme.surfaceDim,
                          thickness: 1,
                        ),
                        rowKeyValue(
                          "Total Price",
                          selectedPaymentMethod != null
                              ? CurrencyFormatter.toRupiah(
                                  (widget.totalPrice +
                                          _parseFee(
                                            selectedPaymentMethod!.fee!,
                                          ))
                                      .toDouble(),
                                )
                              : "-",
                          isBold: true,
                        ),
                      ],
                    ).paddingAll(),
                  ),
                  StateHandler<PaymentMethodCubit,
                      PaginationState<PaymentMethod>>(
                    onRetry: () => getPaymentMethods(),
                    onSuccess: (context, data, _) {
                      final paymentMethods = data.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: MainText(
                              text: "Payment Methods",
                              extent: Large(),
                            ),
                          ),
                          _buildPaymentMethodSections(paymentMethods),
                        ],
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
