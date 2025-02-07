import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/types/paginated_data.dart';
import 'package:paint_car/core/types/pagination.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/template/cubit/template_cubit.dart';
import 'package:paint_car/ui/shared/empty_data.dart';
import 'package:paint_car/ui/shared/state_handler.dart';

class TemplateInfiniteScroll extends StatefulWidget {
  const TemplateInfiniteScroll({super.key});

  @override
  State<TemplateInfiniteScroll> createState() => _TemplateInfiniteScrollState();
}

class _TemplateInfiniteScrollState extends State<TemplateInfiniteScroll> {
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
    context.read<TemplateCubit>().getBrands(page, _limit);
    LogService.i("Load data page $page");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jembut Kusut'),
      ),
      body: StateHandler<TemplateCubit, PaginatedData<CarBrand>>(
        onRetry: () => _loadData(_currentPage),
        onSuccess: (context, data, message) {
          if (!_brands.contains(data.items.firstOrNull)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _brands.addAll(data.items);
                _pagination = data.pagination;
                _isLoadingMore = false;
              });
            });
          }

          if (_brands.isEmpty &&
              _pagination?.currentPage == 1 &&
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
                controller: _scrollController,
                physics:
                    const AlwaysScrollableScrollPhysics(), // Penting untuk RefreshIndicator
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
                        child: Text(_brands[index].name),
                      ),
                      childCount: _brands.length,
                    ),
                  ),
                  if (_isLoadingMore && hasNextPage)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
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
