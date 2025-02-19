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

  List<DropdownMenuItem<PaymentMethod>> _buildDropdownItemGroup(
    MapEntry<PaymentMethodType, List<PaymentMethod>> entry,
  ) {
    return [
      // Header section
      DropdownMenuItem<PaymentMethod>(
        enabled: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            entry.key.toString().split('.').last.replaceAll('_', ' '),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      // Items
      ...entry.value.map(
        (pm) => DropdownMenuItem<PaymentMethod>(
          value: pm,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: pm.logoUrl != null
                  ? ImageNetwork(
                      src: pm.logoUrl!,
                      width: 40,
                      height: 40,
                    )
                  : null,
              title: Text(pm.name),
              subtitle: Text(
                'Fee: ${CurrencyFormatter.toRupiah(_parseFee(pm.fee!).toDouble())}',
              ),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildDropdownSelectedItem(PaymentMethod pm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        pm.name,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPaymentMethodDropdown(List<PaymentMethod> methods) {
    final grouped = _groupPaymentMethods(methods);

    return DropdownButtonFormField<PaymentMethod>(
      value: selectedPaymentMethod,
      decoration: const InputDecoration(
        labelText: 'Payment Method',
        hintText: 'Select payment method',
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
      items: [
        for (var entry in grouped.entries) ..._buildDropdownItemGroup(entry),
      ],
      onChanged: (PaymentMethod? value) {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select payment method';
        }
        return null;
      },
      selectedItemBuilder: (context) {
        return methods.map((pm) => _buildDropdownSelectedItem(pm)).toList();
      },
      isExpanded: true,
    );
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
          title: Text(
            entry.key.toString().split('.').last.replaceAll('_', ' '),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // Jika ingin setiap grup awalnya terbuka, tambahkan properti ini:
          // initiallyExpanded: true,
          children:
              entry.value.map((pm) => _buildPaymentMethodTile(pm)).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod pm) {
    final isSelected = selectedPaymentMethod?.id == pm.id;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: pm.logoUrl != null
            ? ImageNetwork(
                src: pm.logoUrl!,
                width: 40,
                height: 40,
              )
            : null,
        title: Text(pm.name),
        subtitle: Text(
            'Fee: ${CurrencyFormatter.toRupiah(_parseFee(pm.fee!).toDouble())}'),
        trailing: isSelected
            ? Icon(Icons.check_circle,
                color: Theme.of(context).colorScheme.primary)
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
                          widget.carServices.length.toString(),
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
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: MainText(
                                text: "Payment Methods", extent: Large()),
                          ),
                          const SizedBox(height: 8),
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
