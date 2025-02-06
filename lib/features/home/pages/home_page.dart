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

  // Ubah _currentPage menjadi mutable
  int _currentPage = 1;
  final int _limit = 10;

  // Flag untuk mencegah request berulang
  bool _isLoadingMore = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi ScrollController dan tambahkan listener
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load data halaman pertama
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

  // Listener untuk mendeteksi scroll ke bawah
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_pagination != null && _pagination!.hasNextPage && !_isLoadingMore) {
        _isLoadingMore = true;
        _currentPage += 1;
        _loadData(_currentPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, BaseState>(
      listener: (context, state) {
        if (state is BaseSuccessState) {
          final paginatedData = state.data as PaginatedData<CarBrand>;
          LogService.i("Pagination: ${paginatedData.pagination}");
          setState(() {
            _brands.addAll(paginatedData.items);
            _pagination = paginatedData.pagination;
          });
          // setelah data baru berhasil dimuat, set lagi jadi false
          _isLoadingMore = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: StateHandler(
            onRetry: () => _loadData(_currentPage),
            onSuccess: (context, state) {
              if (_brands.isEmpty) {
                return const EmptyData(message: "Brands is empty");
              } else {
                // Tambahkan indikator loading jika masih ada data berikutnya
                final itemCount = _brands.length +
                    ((_pagination != null && _pagination!.hasNextPage) ? 1 : 0);
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index < _brands.length) {
                      final brand = _brands[index];
                      return SizedBox(
                        height: 400,
                        child: Text(brand.name),
                      );
                    } else {
                      // Indikator loading untuk load more
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
