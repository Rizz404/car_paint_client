// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_service.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_services_cubit.dart';
import 'package:paint_car/features/car/pages/car_services/insert_many_car_services_page.dart';
import 'package:paint_car/features/car/pages/car_services/upsert_car_services.dart';
import 'package:paint_car/features/car/widgets/car_services/car_services_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarServicesPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarServicesPage());
  const CarServicesPage({super.key});

  @override
  State<CarServicesPage> createState() => _CarServicesPageState();
}

class _CarServicesPageState extends State<CarServicesPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarServicesCubit>().refresh(_cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarServicesCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarService>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarService>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage(_cancelToken);
    }
  }

  void _delete(
    String id,
  ) async {
    context.read<CarServicesCubit>().deleteService(id, _cancelToken);
  }

  void _onRefresh() {
    context.read<CarServicesCubit>().refresh(_cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Services"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarServicesPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarServicesCubit, PaginationState<CarService>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final services = data.data;

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
                              InsertManyCarServicesPage.route(),
                            );
                          })),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CarServicesItem(
                          service: services[index],
                          onDelete: () {
                            _delete(services[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: services.length,
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
