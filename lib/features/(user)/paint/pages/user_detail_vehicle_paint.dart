import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/local/vehicle_data_sp.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/dependencies/sl.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(user)/paint/widgets/checkbox_paint_panel.dart';
import 'package:paint_car/features/(user)/paint/widgets/color_code_guidance_dialog.dart';
import 'package:paint_car/features/(user)/paint/widgets/select_field_vehicle.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_workshops_page.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/animated_state_handler.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UserDetailVehiclePaintPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserDetailVehiclePaintPage());

  const UserDetailVehiclePaintPage({super.key});

  @override
  State<UserDetailVehiclePaintPage> createState() =>
      _UserDetailVehiclePaintPageState();
}

class _UserDetailVehiclePaintPageState
    extends State<UserDetailVehiclePaintPage> {
  static const int limit = 100;

  late final CancelToken _cancelToken;

  late VehicleData _vehicleData;

  List<String> carServices = [];
  List<String> selectedServices = [];
  bool isSelectAll = false;
  final VehicleDataLocal _vehicleDataLocal = getIt<VehicleDataLocal>();

  Future<void> _loadSavedVehicleData() async {
    final savedData = _vehicleDataLocal.getVehicleData();
    if (savedData != null) {
      setState(() {
        _vehicleData = savedData;
      });

      if (_vehicleData.carBrandId != null) {
        await getModelsByBrandId(_vehicleData.carBrandId);

        if (_vehicleData.carModelId != null) {
          await getColorsByModelId(_vehicleData.carModelId);
        }
      }
    }
  }

  totalPrice() {
    final totalPrice = (context.read<CarServicesCubit>().state
            as BaseSuccessState<PaginationState<CarService>>)
        .data
        .data
        .where(
          (service) => selectedServices.contains(service.id),
        )
        .fold(
          0.0,
          (sum, service) => sum + double.parse(service.price),
        );
    return totalPrice;
  }

  totalServices() {
    return (context.read<CarServicesCubit>().state
            as BaseSuccessState<PaginationState<CarService>>)
        .data
        .data
        .length;
  }

  void _toggleService(String serviceId) {
    setState(() {
      if (selectedServices.contains(serviceId)) {
        selectedServices.remove(serviceId);
      } else {
        selectedServices.add(serviceId);
      }
      isSelectAll = selectedServices.length == carServices.length;
    });
  }

  void _toggleAllServices(List<CarService> services) {
    setState(() {
      isSelectAll = !isSelectAll;
      if (isSelectAll) {
        selectedServices = services.map((e) => e.id!).toList();
      } else {
        selectedServices.clear();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();

    _vehicleData = VehicleData();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        getBrands(),
        getColors(),
        getCarServices(),
      ]);
      _loadSavedVehicleData();
    });
  }

  Future<void> getCarServices() async {
    await context
        .read<CarServicesCubit>()
        .getServices(1, _cancelToken, limit: limit);
  }

  Future<void> getBrands() async {
    await context.read<CarBrandsCubit>().refresh(100, _cancelToken);
  }

  Future<void> getColors() async {
    await context.read<CarColorsCubit>().refresh(
          100,
          _cancelToken,
        );
  }

  Future<void> getModelsByBrandId(String? brandId) async {
    if (brandId == null) return;
    await context.read<CarModelsCubit>().getModelsByBrandId(
          brandId,
          1,
          _cancelToken,
          limit: 100,
        );
  }

  Future<void> getColorsByModelId(String? modelId) async {
    if (modelId == null) return;
    await context.read<CarColorsCubit>().getColorsByModelId(
          modelId,
          1,
          _cancelToken,
          limit: 100,
        );
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Detail Kendaraan"),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildVehicleDetailsSection(),
              _buildLocationCodeColorCar(),
              _buildPaintSelectionSection(),
              const SizedBox(height: 24),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCodeColorCar() {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const ColorCodeGuidanceDialog(),
        );
      },
      child: const MainText(
        text: "Cara menemukan kode warna mobil anda",
        customTextStyle: TextStyle(decoration: TextDecoration.underline),
        extent: Medium(),
      ),
    );
  }

  Widget _buildHeader() {
    return const MainText(
      text: "Detail Pengecatan Kendaraan",
      extent: Large(),
    );
  }

  Widget _buildVehicleDetailsSection() {
    final divider = const Divider(
      // color: CustomColors.gray,
      thickness: 1,
    );

    return Column(
      children: [
        _buildBrandsSelectField(divider),
        _buildModelSelectField(divider),
        _buildColorsByModelIdSelectField(divider),
      ],
    );
  }

  Widget _buildBrandsSelectField(Widget divider) {
    return StateHandler<CarBrandsCubit, PaginationState<CarBrand>>(
      onRetry: () => getBrands(),
      onSuccess: (context, data, _) {
        final brands = data.data;
        if (brands.isEmpty) return const SizedBox();
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Merek Mobil*",
              value: _vehicleData.carBrand ?? '',
              options: brands.map((e) => e.name).toList(),
              onSelected: (value) {
                final selectedBrand =
                    brands.firstWhere((element) => element.name == value);
                getModelsByBrandId(selectedBrand.id);
                setState(() {
                  _vehicleData.carBrand = value;
                  _vehicleData.carBrandId = selectedBrand.id;

                  _vehicleData.carModel = null;
                  _vehicleData.carModelId = null;
                  _vehicleData.carColor = null;
                  _vehicleData.carColorId = null;
                });
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildModelSelectField(Widget divider) {
    return AnimatedStateHandler<CarModelsCubit, PaginationState<CarModel>>(
      show: _vehicleData.carBrandId != null,
      onRetry: () => _vehicleData.carBrandId != null
          ? getModelsByBrandId(_vehicleData.carBrandId!)
          : Future.value(),
      onSuccess: (context, data, _) {
        final models = data.data;
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Model Mobil*",
              value: _vehicleData.carModel ?? '',
              options: models.map((e) => e.name).toList(),
              onSelected: (value) {
                final selectedModel =
                    models.firstWhere((element) => element.name == value);
                setState(() {
                  _vehicleData.carModel = value;
                  _vehicleData.carModelId = selectedModel.id;

                  _vehicleData.carColor = null;
                  _vehicleData.carColorId = null;
                });

                getColorsByModelId(_vehicleData.carModelId);
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildColorsByModelIdSelectField(Widget divider) {
    return AnimatedStateHandler<CarColorsCubit, PaginationState<CarColor>>(
      show: _vehicleData.carModelId != null,
      onRetry: () => _vehicleData.carModelId != null
          ? getColorsByModelId(
              _vehicleData.carModelId!,
            )
          : Future.value(),
      onSuccess: (context, data, _) {
        final colors = data.data;
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Warna Mobil*",
              value: _vehicleData.carColor ?? '',
              options: colors.map((e) => e.name).toList(),
              onSelected: (value) {
                final selectedColor =
                    colors.firstWhere((element) => element.name == value);
                setState(() {
                  _vehicleData.carColor = value;
                  _vehicleData.carColorId = selectedColor.id;
                });
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildPaintSelectionSection() {
    return Column(
      spacing: 16,
      children: [
        const MainText(
          text: "Pilih Bagian yang Ingin di Cat",
          extent: Large(),
        ),
        _buildPaintCheckboxes(),
      ],
    );
  }

  Widget _buildPaintCheckboxes() {
    return StateHandler<CarServicesCubit, PaginationState<CarService>>(
      onRetry: () => getCarServices(),
      onSuccess: (context, data, _) {
        final services = data.data;
        if (carServices.isEmpty && services.isNotEmpty) {
          carServices = services.map((e) => e.id!).toList();
        }

        double totalPriceFromDb = 0;
        for (var service in services) {
          if (carServices.contains(service.id)) {
            totalPriceFromDb += double.parse(service.price);
          }
        }

        return Column(
          spacing: 12,
          children: [
            _buildCheckboxPaintPanel(
              "assets/images/car/black_car_full_body.png",
              "Semua",
              isSelectAll,
              totalPriceFromDb.toString(),
              (value) {
                _toggleAllServices(services);
              },
              isImageNetwork: false,
            ),
            ...services.map(
              (service) => _buildCheckboxPaintPanel(
                service.carServiceImage!,
                service.name,
                selectedServices.contains(service.id),
                service.price,
                (value) {
                  _toggleService(service.id!);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxPaintPanel(
    String imageAsset,
    String title,
    bool isSelected,
    String price,
    void Function(bool?) onChanged, {
    bool isImageNetwork = true,
  }) {
    return CheckboxPaintPanel(
      imageAsset: imageAsset,
      title: title,
      value: isSelected,
      onChanged: onChanged,
      isImageNetwork: isImageNetwork,
      price: price,
    );
  }

  Widget _buildNextButton() {
    return MainElevatedButton(
      onPressed: _handleNextButton,
      text: "Pilih Warna",
      borderRadius: 10,
    );
  }

  void _handleNextButton() {
    if (_vehicleData.carModelId == null ||
        _vehicleData.carColorId == null ||
        selectedServices.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Mohon lengkapi data terlebih dahulu",
        type: SnackBarType.warning,
      );
      return;
    }
    _vehicleDataLocal.saveVehicleData(_vehicleData);

    Navigator.of(context).push(
      UserWorkshopsPage.route(
        vehicleData: _vehicleData,
        carServices: selectedServices,
        carModelColorId: _vehicleData.carModelColorId ?? '',
        carModelId: _vehicleData.carModelId!,
        carColorId: _vehicleData.carColorId!,
        totalAllServices: totalServices(),
        totalPrice: totalPrice(),
      ),
    );
  }
}
