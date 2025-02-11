// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/car_workshop.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_workshops_cubit.dart';
import 'package:paint_car/features/car/pages/car_workshops/upsert_car_workshops.dart';
import 'package:paint_car/features/car/widgets/car_workshops/car_workshops_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarWorkshopsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarWorkshopsPage());
  const CarWorkshopsPage({super.key});

  @override
  State<CarWorkshopsPage> createState() => _CarWorkshopsPageState();
}

class _CarWorkshopsPageState extends State<CarWorkshopsPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarWorkshopsCubit>().refresh(_cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarWorkshopsCubit>();
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
      cubit.loadNextPage(_cancelToken);
    }
  }

  void _delete(
    String id,
  ) async {
    context.read<CarWorkshopsCubit>().deleteWorkshop(id, _cancelToken);
  }

  void _onRefresh() {
    context.read<CarWorkshopsCubit>().refresh(_cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Workshops"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarWorkshopsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarWorkshopsCubit, PaginationState<CarWorkshop>>(
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CarWorkshopsItem(
                          workshop: workshops[index],
                          onDelete: () {
                            _delete(workshops[index].id!);
                          },
                          onRefresh: _onRefresh),
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
