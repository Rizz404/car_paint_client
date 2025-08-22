import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/workshop/cubit/user_workshops_cubit.dart';
import 'package:paint_car/features/(user)/workshop/widgets/user_workshops_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class UserWorkshopsPage extends StatefulWidget {
  static route({
    required VehicleData vehicleData,
    required List<String> carServices,
    required String carModelId,
    required String carColorId,
    required String carModelColorId,
    required double totalPrice,
    required int totalAllServices,
    required List<File> carColors,
  }) =>
      MaterialPageRoute(
        builder: (_) => UserWorkshopsPage(
          vehicleData: vehicleData,
          carColors: carColors,
          carServices: carServices,
          carModelId: carModelId,
          carColorId: carColorId,
          carModelColorId: vehicleData.carModelColorId ?? "",
          totalPrice: totalPrice,
          totalAllServices: totalAllServices,
        ),
      );
  final VehicleData vehicleData;
  final List<String> carServices;

  final String carColorId;
  final String carModelId;
  final String carModelColorId;
  final double totalPrice;
  final List<File> carColors;
  final int totalAllServices;
  const UserWorkshopsPage({
    super.key,
    required this.vehicleData,
    required this.carColors,
    required this.carServices,
    required this.carModelId,
    required this.carColorId,
    required this.carModelColorId,
    required this.totalPrice,
    required this.totalAllServices,
  });

  @override
  State<UserWorkshopsPage> createState() => _UserWorkshopsPageState();
}

class _UserWorkshopsPageState extends State<UserWorkshopsPage> {
  static const limit = ApiConstant.limit;
  late final ScrollController _scrollController;
  late final CancelToken _cancelToken;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition();
          double lat = position.latitude;
          double lng = position.longitude;
          setState(() {
            latitude = lat;
            longitude = lng;
          });
        }
        _onRefresh();
      } catch (e) {
        SnackBarUtil.showSnackBar(
          context: context,
          message: "Error getting current location",
          type: SnackBarType.error,
        );
        LogService.e("Error getting current location ${e.toString()}");
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cancelToken.cancel();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<UserWorkshopCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarWorkshop>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarWorkshop>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage(
        _cancelToken,
      );
    }
  }

  void _onRefresh() async {
    await context.read<UserWorkshopCubit>().getNearestWorkshops(
          1,
          limit: 200,
          latitude!,
          longitude!,
          _cancelToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateHandler<UserWorkshopCubit, PaginationState<CarWorkshop>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final workshops = data.data;

          return RefreshIndicator(
            onRefresh: () async {
              _onRefresh();
            },
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: CustomScrollView(
                cacheExtent: 2000,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => UserWorkshopsItem(
                        workshop: workshops[index],
                        onRefresh: _onRefresh,
                        vehicleData: widget.vehicleData,
                        carServices: widget.carServices,
                        carColorId: widget.carColorId,
                        carModelId: widget.carModelId,
                        carModelColorId: widget.carModelColorId,
                        totalPrice: widget.totalPrice,
                        totalAllServices: widget.totalAllServices,
                        carColors: widget.carColors,
                      ),
                      childCount: workshops.length,
                    ),
                  ),
                  if (data.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Loading(),
                    ),
                ],
              ),
            ),
          ).paddingOnly(top: 30);
        },
      ),
    );
  }
}
