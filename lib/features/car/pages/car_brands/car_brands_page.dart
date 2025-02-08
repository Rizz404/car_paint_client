// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/car/pages/car_brands/upsert_car_brands.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/shared/empty_data.dart';
import 'package:paint_car/ui/shared/loading.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/state_handler.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';

class CarBrandsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const CarBrandsPage());
  const CarBrandsPage({super.key});

  @override
  State<CarBrandsPage> createState() => _CarBrandsPageState();
}

class _CarBrandsPageState extends State<CarBrandsPage> {
  final List<CarBrand> _brands = [];
  Pagination? _pagination;
  int _currentPage = 1;
  final int _limit = 10;
  bool _isLoadingMore = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadData(_currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _currentPage = 1;
      _brands.clear();
      _pagination = null;
      _isLoadingMore = false;
    });
    _loadData(_currentPage);
  }

  void _loadData(int page) {
    if (page == 1) {
      _brands.clear();
    }
    context.read<CarBrandsCubit>().getBrands(page, _limit);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final hasNextPage = _pagination?.hasNextPage ?? false;
    if (currentScroll >= maxScroll - 200 && !_isLoadingMore && hasNextPage) {
      setState(() => _isLoadingMore = true);
      _currentPage += 1;
      _loadData(_currentPage);
    }
  }

  void _delete(int index) async {
    final brandId = _brands[index].id!;

    setState(() {
      _brands.removeAt(index);
    });

    await context.read<CarBrandsCubit>().deleteBrand(brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Car Brands"),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).push(UpsertCarBrands.route()).then(
          (_) {
            _onRefresh();
          },
        ),
        child: const Icon(Icons.add),
      ),
      body: StateHandler<CarBrandsCubit, PaginatedData<CarBrand>>(
        onRetry: () => _loadData(_currentPage),
        onSuccess: (context, data, message) {
          if (!_brands.contains(data.items.firstOrNull)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_currentPage == 1) {
                _brands.clear();
              }

              setState(() {
                _brands.addAll(
                  data.items.where((item) => !_brands.contains(item)),
                );
                _pagination = data.pagination;
                _isLoadingMore = false;
              });
            });
          }

          if (_brands.isEmpty &&
              (_pagination?.currentPage ?? 1) == 1 &&
              _isLoadingMore &&
              _pagination?.hasNextPage == false) {
            return const EmptyData(message: "Brands is empty");
          }

          final hasNextPage = _pagination?.hasNextPage ?? false;
          return RefreshIndicator(
            onRefresh: _onRefresh,
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
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.blueAccent,
                      child: const Text(
                        'Konten di atas ListView',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => SizedBox(
                        height: 200,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .push(UpsertCarBrands.route(
                            carBrand: _brands[index],
                          ))
                              .then(
                            (_) {
                              _onRefresh();
                            },
                          ),
                          child: BlocConsumer<CarBrandsCubit, BaseState>(
                            listener: (context, state) {
                              handleFormListenerState(
                                context: context,
                                state: state,
                                onRetry: () {
                                  _delete(index);
                                },
                                onSuccess: () {
                                  SnackBarUtil.showSnackBar(
                                    context: context,
                                    message: "Car brand deleted successfully",
                                    type: SnackBarType.success,
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(_brands[index].name),
                                      IconButton(
                                          onPressed: () {
                                            _delete(index);
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                  Image.network(
                                    _brands[index].logo!,
                                    fit: BoxFit.contain,
                                    height: 100,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      childCount: _brands.length,
                    ),
                  ),
                  if (_isLoadingMore && hasNextPage)
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
