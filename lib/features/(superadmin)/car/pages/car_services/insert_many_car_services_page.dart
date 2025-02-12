import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class InsertManyCarServicesPage extends StatefulWidget {
  const InsertManyCarServicesPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const InsertManyCarServicesPage(),
      );

  @override
  State<InsertManyCarServicesPage> createState() =>
      _InsertManyCarServicesPageState();
}

class _InsertManyCarServicesPageState extends State<InsertManyCarServicesPage> {
  late final CancelToken _cancelToken;
  final List<ServiceFormData> _services = [ServiceFormData()];
  final _formKey = GlobalKey<FormState>();

  void _addService() => setState(() => _services.add(ServiceFormData()));

  void _removeService(int index) => setState(() => _services.removeAt(index));

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
  }

  @override
  dispose() {
    _cancelToken.cancel();
    _services.forEach((b) => b.dispose());
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final validServices = _services.where((b) => b.isValid).toList();
    final invalidServices = _services.where((b) => !b.isValid).toList();

    if (invalidServices.isNotEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please fill all fields for each service",
        type: SnackBarType.error,
      );
      return;
    }

    context.read<CarServicesCubit>().saveManyServices(
          validServices.map((b) => b.toCarService()).toList(),
          _cancelToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarServicesCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: _submit,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Multiple services created successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar("Create Multiple Services"),
          body: Form(
            key: _formKey,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              itemBuilder: (ctx, i) => ServiceFormItem(
                key: ValueKey(i),
                data: _services[i],
                onRemove: () => _removeService(i),
                index: i + 1,
                isEnabled: state is! BaseLoadingState,
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'add',
                onPressed: _addService,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'save',
                onPressed: state is! BaseLoadingState ? _submit : null,
                child: state is BaseLoadingState
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.save),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ServiceFormData {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool get isValid =>
      nameController.text.isNotEmpty && priceController.text.isNotEmpty;

  CarService toCarService() => CarService(
        name: nameController.text,
        price: priceController.text,
      );

  void dispose() {
    nameController.dispose();
  }
}

class ServiceFormItem extends StatefulWidget {
  final ServiceFormData data;
  final ValueChanged<ServiceFormData>? onChanged;
  final VoidCallback? onRemove;
  final int index;
  final bool isEnabled;

  const ServiceFormItem({
    super.key,
    required this.data,
    this.onChanged,
    this.onRemove,
    required this.index,
    this.isEnabled = true,
  });

  @override
  State<ServiceFormItem> createState() => _ServiceFormItemState();
}

class _ServiceFormItemState extends State<ServiceFormItem> {
  @override
  void dispose() {
    widget.data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MainText(
                  text: "Service #${widget.index}",
                  extent: const Medium(),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: widget.isEnabled ? widget.onRemove : null,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 16),
            MainTextField(
              controller: widget.data.nameController,
              hintText: "Enter service name",
              leadingIcon: const Icon(Icons.car_rental),
              isEnabled: widget.isEnabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Service name cannot be empty";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // get car brands
            // jadiin dropdown
          ],
        ),
      ),
    );
  }
}
