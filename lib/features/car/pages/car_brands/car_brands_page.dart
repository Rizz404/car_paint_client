// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/pages/car_brands/insert_many_car_brands_page.dart';
import 'package:paint_car/features/car/pages/car_brands/upsert_car_brands_page.dart';
import 'package:paint_car/features/car/widgets/car_brands/car_brands_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarBrandsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarBrandsPage());
  const CarBrandsPage({super.key});

  @override
  State<CarBrandsPage> createState() => _CarBrandsPageState();
}

class _CarBrandsPageState extends State<CarBrandsPage> {
  static const limit = ApiConstant.limit;
  late final ScrollController _scrollController;
  late final CancelToken _cancelToken;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarBrandsCubit>().refresh(limit, _cancelToken);
  }

  // void evictCachedImages() {
  //   for (final brand in _brands) {
  //     if (brand.logo == null) return;
  //     precacheImage(NetworkImage(brand.logo!), context);
  //   }
  // }

  @override
  void dispose() {
    _scrollController.dispose();
    _cancelToken.cancel();
    // evictCachedImages();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarBrandsCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarBrand>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarBrand>>).data;
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

  void _delete(
    String id,
  ) async {
    context.read<CarBrandsCubit>().deleteBrand(id, _cancelToken);
  }

  void _onRefresh() {
    LogService.i("ON RETRY");
    context.read<CarBrandsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Brands"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarBrandsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarBrandsCubit, PaginationState<CarBrand>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final brands = data.data;

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
                      child: MainElevatedButton(
                          text: "Create Many",
                          onPressed: () {
                            Navigator.of(context).push(
                              InsertManyCarBrandsPage.route(),
                            );
                          })),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CarBrandsItem(
                          brand: brands[index],
                          onDelete: () {
                            _delete(brands[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: brands.length,
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
