// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_models_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_models/insert_many_car_models_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_models/upsert_car_models.dart';
import 'package:paint_car/features/(superadmin)/car/widgets/car_models/car_models_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarModelsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarModelsPage());
  const CarModelsPage({super.key});

  @override
  State<CarModelsPage> createState() => _CarModelsPageState();
}

class _CarModelsPageState extends State<CarModelsPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;
  static const limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarModelsCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cancelToken.cancel();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarModelsCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarModel>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarModel>>).data;
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
    context.read<CarModelsCubit>().deleteModel(id, _cancelToken);
  }

  void _onRefresh() async {
    await context.read<CarModelsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Models"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarModelsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarModelsCubit, PaginationState<CarModel>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final models = data.data;

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
                              InsertManyCarModelsPage.route(),
                            );
                          })),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CarModelsItem(
                          model: models[index],
                          onDelete: () {
                            _delete(models[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: models.length,
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
