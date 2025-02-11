// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_model_year_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_model_year_color_cubit.dart';
import 'package:paint_car/features/car/pages/car_model_year_color/upsert_car_model_year_color_.dart';
import 'package:paint_car/features/car/widgets/car_model_year_color/car_model_year_color_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarModelYearColorPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const CarModelYearColorPage());
  const CarModelYearColorPage({super.key});

  @override
  State<CarModelYearColorPage> createState() => _CarModelYearColorPageState();
}

class _CarModelYearColorPageState extends State<CarModelYearColorPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;
  static const limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarModelYearColorCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cancelToken.cancel();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarModelYearColorCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarModelYearColor>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarModelYearColor>>)
            .data;
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
    context.read<CarModelYearColorCubit>().deleteModel(id, _cancelToken);
  }

  void _onRefresh() {
    context.read<CarModelYearColorCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car ModelYearColor"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarModelYearColor.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarModelYearColorCubit,
          PaginationState<CarModelYearColor>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final modelYearColor = data.data;

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
                      (context, index) => CarModelYearColorItem(
                          model: modelYearColor[index],
                          onDelete: () {
                            _delete(modelYearColor[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: modelYearColor.length,
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
