// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_color.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_colors_cubit.dart';
import 'package:paint_car/features/car/pages/car_colors/insert_many_car_colors_page.dart';
import 'package:paint_car/features/car/pages/car_colors/upsert_car_colors.dart';
import 'package:paint_car/features/car/widgets/car_colors/car_colors_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarColorsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarColorsPage());
  const CarColorsPage({super.key});

  @override
  State<CarColorsPage> createState() => _CarColorsPageState();
}

class _CarColorsPageState extends State<CarColorsPage> {
  late final ScrollController _scrollController;
  static const int limit = ApiConstant.limit;
  late final CancelToken _cancelToken;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    _onRefresh();
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarColorsCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarColor>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarColor>>).data;
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
    await context.read<CarColorsCubit>().deleteColor(id, _cancelToken);
  }

  void _onRefresh() async {
    await context.read<CarColorsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Colors"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarColorsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarColorsCubit, PaginationState<CarColor>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final colors = data.data;

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
                  // SliverToBoxAdapter(
                  //     child: MainElevatedButton(
                  //         text: "Create Many",
                  //         onPressed: () {
                  //           Navigator.of(context).push(
                  //             InsertManyCarColorsPage.route(),
                  //           );
                  //         })),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CarColorsItem(
                          color: colors[index],
                          onDelete: () {
                            _delete(colors[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: colors.length,
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
