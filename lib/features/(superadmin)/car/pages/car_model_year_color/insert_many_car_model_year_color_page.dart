import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class InsertManyCarModelsPage extends StatefulWidget {
  const InsertManyCarModelsPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const InsertManyCarModelsPage(),
      );

  @override
  State<InsertManyCarModelsPage> createState() =>
      _InsertManyCarModelsPageState();
}

class _InsertManyCarModelsPageState extends State<InsertManyCarModelsPage> {
  late final CancelToken _cancelToken;
  final List<ModelFormData> _models = [ModelFormData()];
  final _formKey = GlobalKey<FormState>();

  void _addModel() => setState(() => _models.add(ModelFormData()));

  void _removeModel(int index) => setState(() => _models.removeAt(index));

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
  }

  @override
  dispose() {
    _cancelToken.cancel();
    _models.forEach((b) => b.dispose());
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final validModels = _models.where((b) => b.isValid).toList();
    final invalidModels = _models.where((b) => !b.isValid).toList();

    if (invalidModels.isNotEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please fill all fields and select image for each model",
        type: SnackBarType.error,
      );
      return;
    }

    context.read<CarModelsCubit>().saveManyModels(
          validModels.map((b) => b.toCarModel()).toList(),
          _cancelToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarModelsCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: _submit,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Multiple models created successfully",
              type: SnackBarType.success,
            );
            Navigator.pop(context);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar("Create Multiple Models"),
          body: Form(
            key: _formKey,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _models.length,
              itemBuilder: (ctx, i) => ModelFormItem(
                key: ValueKey(i),
                data: _models[i],
                onRemove: () => _removeModel(i),
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
                onPressed: _addModel,
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

class ModelFormData {
  final TextEditingController nameController = TextEditingController();
  var carBrandId = "";

  bool get isValid => nameController.text.isNotEmpty && carBrandId.isNotEmpty;

  CarModel toCarModel() => CarModel(
        name: nameController.text,
        carBrandId: carBrandId,
      );

  void dispose() {
    nameController.dispose();
  }
}

class ModelFormItem extends StatefulWidget {
  final ModelFormData data;
  final ValueChanged<ModelFormData>? onChanged;
  final VoidCallback? onRemove;
  final int index;
  final bool isEnabled;

  const ModelFormItem({
    super.key,
    required this.data,
    this.onChanged,
    this.onRemove,
    required this.index,
    this.isEnabled = true,
  });

  @override
  State<ModelFormItem> createState() => _ModelFormItemState();
}

class _ModelFormItemState extends State<ModelFormItem> {
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
                  text: "Model #${widget.index}",
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
              hintText: "Enter model name",
              leadingIcon: const Icon(Icons.car_rental),
              isEnabled: widget.isEnabled,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Model name cannot be empty";
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
