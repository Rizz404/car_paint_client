// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/upsert_user_car_page.dart';
import 'package:paint_car/features/(user)/car/widgets/user_car_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/shared/common_state.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

// ! design example
class UserCarPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const UserCarPage());
  const UserCarPage({super.key});

  @override
  State<UserCarPage> createState() => _UserCarPageState();
}

class _UserCarPageState extends State<UserCarPage> {
  static const limit = ApiConstant.limit;
  late final ScrollController _scrollController;
  late final CancelToken _cancelToken;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<UserCarCubit>().getUserCars(
          1,
          _cancelToken,
        );
  }

  // void evictCachedImages() {
  //   for (final userCar in _userCars) {
  //     if (userCar.logo == null) return;
  //     precacheImage(NetworkImage(userCar.logo!), context);
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
    final cubit = context.read<UserCarCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<UserCar>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<UserCar>>).data;
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
    await context.read<UserCarCubit>().deleteUserCar(id, _cancelToken);
  }

  void _onRefresh() async {
    await context.read<UserCarCubit>().refresh(limit, _cancelToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car UserCars"),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(UpsertUserCarPage.route()),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<UserCarCubit, PaginationState<UserCar>>(
        onRetry: () => _onRefresh(),
        onSuccess: (context, data, message) {
          final userCars = data.data;

          if (userCars.isEmpty) {
            return const CommonState(
              title: 'Mobil anda kosong, silahkan tambahkan mobil',
              description: 'Klik tombol + untuk menambahkan mobil',
            );
          }
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
                      (context, index) => UserCarItem(
                          userCar: userCars[index],
                          onDelete: () {
                            _delete(userCars[index].id!);
                          },
                          onRefresh: _onRefresh),
                      childCount: userCars.length,
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
