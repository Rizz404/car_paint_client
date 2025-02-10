// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/e_ticket.dart';
import 'package:paint_car/data/models/payment_method.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/financial/cubit/e_tickets_cubit.dart';
import 'package:paint_car/features/financial/cubit/payment_method_cubit.dart';
import 'package:paint_car/features/financial/widgets/payment_method_item.dart';
import 'package:paint_car/features/shared/types/pagination_state.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class PaymentMethodPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const PaymentMethodPage());
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late final ScrollController _scrollController;
  static const int limit = ApiConstant.limit;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<PaymentMethodCubit>().refresh(limit);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    final cubit = context.read<PaymentMethodCubit>();
    if (!_scrollController.hasClients ||
        cubit.state is! BaseSuccessState<PaginationState<PaymentMethod>>) {
      return;
    }

    final data =
        (cubit.state as BaseSuccessState<PaginationState<PaymentMethod>>).data;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200 &&
        !data.isLoadingMore &&
        data.pagination.hasNextPage) {
      cubit.loadNextPage();
    }
  }

  void _onRefresh() {
    context.read<PaymentMethodCubit>().refresh(limit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Models"),
      body: StateHandler<PaymentMethodCubit, PaginationState<PaymentMethod>>(
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
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          PaymentMethodItem(order: models[index]),
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
