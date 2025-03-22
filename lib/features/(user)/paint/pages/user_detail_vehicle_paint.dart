import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/(user)/paint/widgets/checkbox_paint_panel.dart';
import 'package:paint_car/features/(user)/paint/widgets/select_field_vehicle.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_workshops_page.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
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
  totalPrice() {
    final totalPrice = (context.read<CarServicesCubit>().state
            as BaseSuccessState<PaginationState<CarService>>)
        .data
        .data
        .where(
          (service) => selectedServices.contains(service.id),
        )
        .fold(
          0.0, // ! ini biar double yh
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

  Future<void> getModelYearsByModelId(String? modelId) async {
    if (modelId == null) return;
    await context.read<CarModelYearsCubit>().getModelYearsByCarModel(
          modelId,
          1,
          _cancelToken,
          limit: 100,
        );
  }

  Future<void> getModelYearColors(String? modelYearId, String? colorId) async {
    if (modelYearId == null || colorId == null) return;
    await context
        .read<CarModelYearColorCubit>()
        .getModelYearColorByModelAndColor(
          modelYearId,
          colorId,
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
      appBar: mainAppBar("Detail Vehicle Paint"),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          child: Column(
            spacing: 24,
            children: [
              _buildHeader(),
              _buildVehicleDetailsSection(),
              _buildPaintSelectionSection(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const MainText(
      text: "Detail Kendaraan Dan Pengecatan",
      extent: Large(),
    );
  }

  Widget _buildVehicleDetailsSection() {
    final divider = const Divider(
      color: CustomColors.gray,
      thickness: 1,
    );

    return Column(
      children: [
        _buildBrandsSelectField(divider),
        _buildColorSelectField(divider),
        _buildModelSelectField(divider),
        _buildModelYearSelectField(divider),
        _buildModelYearColotSelectField(),
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
              field: "Brand Mobil*",
              value: _vehicleData.carBrand ?? '',
              options: brands.map((e) => e.name).toList(),
              onSelected: (value) {
                getModelsByBrandId(
                  brands.firstWhere((element) => element.name == value).id,
                );
                setState(() {
                  _vehicleData.carBrand = value;
                  _vehicleData.carBrandId =
                      brands.firstWhere((element) => element.name == value).id;
                  _vehicleData.carModel = null;
                  _vehicleData.carModelYear = null;
                  _vehicleData.carModelYearColor = null;
                });
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildColorSelectField(Widget divider) {
    return StateHandler<CarColorsCubit, PaginationState<CarColor>>(
      onRetry: () => getColors(),
      onSuccess: (context, data, _) {
        final colors = data.data;
        if (colors.isEmpty) return const SizedBox();
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Warna Mobil*",
              value: _vehicleData.carColor ?? '',
              options: colors.map((e) => e.name).toList(),
              onSelected: (value) {
                setState(() {
                  _vehicleData.carColor = value;
                  _vehicleData.carColorId =
                      colors.firstWhere((element) => element.name == value).id;
                  _vehicleData.carModel = null;
                  _vehicleData.carModelYear = null;
                  _vehicleData.carModelYearColor = null;
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
                setState(() {
                  _vehicleData.carModel = value;
                  _vehicleData.carModelId =
                      models.firstWhere((element) => element.name == value).id;
                  _vehicleData.carModelYear = null;
                  _vehicleData.carModelYearColor = null;
                });
                getModelYearsByModelId(_vehicleData.carModelId);
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildModelYearSelectField(Widget divider) {
    return AnimatedStateHandler<CarModelYearsCubit,
        PaginationState<CarModelYears>>(
      show: _vehicleData.carModelId != null,
      onRetry: () => _vehicleData.carModelId != null
          ? getModelYearsByModelId(_vehicleData.carModelId!)
          : Future.value(),
      onSuccess: (context, data, _) {
        final modelYears = data.data;
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Model Tahun Mobil*",
              value: _vehicleData.carModelYear ?? '',
              options: modelYears.map((e) => e.year.toString()).toList(),
              onSelected: (value) {
                setState(() {
                  _vehicleData.carModelYear = value;
                  _vehicleData.carModelYearId = modelYears
                      .firstWhere((element) => element.year.toString() == value)
                      .id;
                  _vehicleData.carModelYearColor = null;
                });
                getModelYearColors(
                  _vehicleData.carModelYearId,
                  _vehicleData.carColorId,
                );
              },
            ),
            divider,
          ],
        );
      },
    );
  }

  Widget _buildModelYearColotSelectField() {
    return AnimatedStateHandler<CarModelYearColorCubit,
        PaginationState<CarModelYearColor>>(
      show: _vehicleData.carModelYearId != null &&
          _vehicleData.carColorId != null,
      onRetry: () =>
          _vehicleData.carModelYearId != null && _vehicleData.carColorId != null
              ? getModelYearColors(
                  _vehicleData.carModelYearId!,
                  _vehicleData.carColorId!,
                )
              : Future.value(),
      onSuccess: (context, data, _) {
        final modelYearColor = data.data;
        return Column(
          children: [
            SelectFieldVehicle(
              field: "Model Tahun Warna Mobil*",
              value: _vehicleData.carModelYearColor ?? '',
              options: modelYearColor.map((e) => e.color!.name).toList(),
              onSelected: (value) {
                setState(() {
                  _vehicleData.carModelYearColor = value;
                  _vehicleData.carModelYearColorId = modelYearColor
                      .firstWhere((element) => element.color!.name == value)
                      .id;
                });
              },
            ),
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
    ).paddingSymmetric(horizontal: 16);
  }

  Widget _buildPaintCheckboxes() {
    return StateHandler<CarServicesCubit, PaginationState<CarService>>(
      onRetry: () => getCarServices(),
      onSuccess: (context, data, _) {
        final services = data.data;
        if (carServices.isEmpty && services.isNotEmpty) {
          carServices = services.map((e) => e.id!).toList();
        }

        return Column(
          spacing: 12,
          children: [
            _buildCheckboxPaintPanel(
              "assets/images/car/black_car_full_body.png",
              "Full Body",
              isSelectAll,
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
    void Function(bool?) onChanged, {
    bool isImageNetwork = true,
  }) {
    return CheckboxPaintPanel(
      imageAsset: imageAsset,
      title: title,
      value: isSelected,
      onChanged: onChanged,
      isImageNetwork: isImageNetwork,
    );
  }

  Widget _buildNextButton() {
    return MainElevatedButton(
      onPressed: _handleNextButton,
      text: "Selanjutnya",
      bgColor: CustomColors.blue,
      borderRadius: 10,
    );
  }

  void _handleNextButton() {
    if (_vehicleData.carModelYearId == null ||
        _vehicleData.carColorId == null ||
        carServices.isEmpty) {
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Mohon lengkapi data terlebih dahulu",
        type: SnackBarType.warning,
      );
      return;
    }
    Navigator.of(context).push(
      UserWorkshopsPage.route(
        vehicleData: _vehicleData,
        carServices: selectedServices,
        carModelYearId: _vehicleData.carModelYearId!,
        colorId: _vehicleData.carColorId!,
        totalAllServices: totalServices(),
        totalPrice: totalPrice(),
      ),
    );
  }
}
