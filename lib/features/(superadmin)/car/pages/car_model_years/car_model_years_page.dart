// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/car_model_years.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_model_years_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_model_years/upsert_car_model_years.dart';
import 'package:paint_car/features/(superadmin)/car/widgets/car_model_years/car_models_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class CarModelYearsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const CarModelYearsPage());
  const CarModelYearsPage({super.key});

  @override
  State<CarModelYearsPage> createState() => _CarModelYearsPageState();
}

class _CarModelYearsPageState extends State<CarModelYearsPage> {
  late final CancelToken _cancelToken;
  late final ScrollController _scrollController;
  static const int limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<CarModelYearsCubit>().refresh(limit, _cancelToken);
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<CarModelYearsCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<CarModelYears>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<CarModelYears>>).data;
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
    context.read<CarModelYearsCubit>().deleteModelYear(id, _cancelToken);
  }

  void _onRefresh() {
    context.read<CarModelYearsCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Model Years"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarModelYearsPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarModelYearsCubit, PaginationState<CarModelYears>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final modelYearsCarModelYears = data.data;

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
                      (context, index) => CarModelYearsItem(
                          model: modelYearsCarModelYears[index],
                          onDelete: () {
                            _delete(modelYearsCarModelYears[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: modelYearsCarModelYears.length,
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
