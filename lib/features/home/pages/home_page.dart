import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/home/cubit/home_cubit.dart';
import 'package:paint_car/ui/shared/empty_data.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _loadData(int page) {
    context.read<HomeCubit>().getBrands(page, _limit);
  }

  void _onScroll() {
    final currentScroll = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final hasNextPage = _pagination != null && _pagination!.hasNextPage;

    if (currentScroll <= maxScroll - 200) {
      return;
    }

    if (!hasNextPage || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    _currentPage += 1;
    _loadData(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, BaseState>(
      listener: (context, state) {
        if (state is BaseSuccessState) {
          final data = state.data as PaginatedData<CarBrand>;
          setState(() {
            _brands.addAll(data.items);
            _pagination = data.pagination;
            _isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Jembut Kusut'),
          ),
          body: StateHandler(
            onRetry: () => _loadData(_currentPage),
            onSuccess: (context, state) {
              if (_brands.isEmpty) {
                return const EmptyData(message: "Brands is empty");
              }
              final hasNextPage =
                  _pagination != null && _pagination!.hasNextPage;
              final itemCount = _brands.length + ((hasNextPage) ? 1 : 0);
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: CustomScrollView(
                  controller: _scrollController,
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
                        (context, index) {
                          if (index == _brands.length) {
                            // ! loading nya nutupin layout items
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final brand = _brands[index];
                          return SizedBox(
                            height: 200,
                            child: Text(brand.name),
                          );
                        },
                        childCount: itemCount,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
