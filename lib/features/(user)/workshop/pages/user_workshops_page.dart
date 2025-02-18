// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/workshop/cubit/user_workshops_cubit.dart';
import 'package:paint_car/features/(user)/workshop/widgets/user_workshops_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

// ! design example
class UserWorkshopsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserWorkshopsPage());
  const UserWorkshopsPage({super.key});

  @override
  State<UserWorkshopsPage> createState() => _UserWorkshopsPageState();
}

class _UserWorkshopsPageState extends State<UserWorkshopsPage> {
  // ignore: unused_field
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
      appBar: mainAppBar("Car Workshops"),
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
                cacheExtent: 2000, // ! Preload area di luar viewport
                controller: _scrollController,
                physics:
                    const AlwaysScrollableScrollPhysics(), // buat RefreshIndicator
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Showing ${workshops.length} workshops",
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => UserWorkshopsItem(
                          workshop: workshops[index], onRefresh: _onRefresh),
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
          );
        },
      ),
    );
  }
}
