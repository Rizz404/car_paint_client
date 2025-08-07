import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_history_cubit.dart';
import 'package:paint_car/features/(user)/financial/cubit/user_transactions_cubit.dart';
import 'package:paint_car/features/home/widgets/user_history_in_booking.dart';
import 'package:paint_car/features/home/widgets/user_transactions_in_booking.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/ui/extension/padding.dart';

class MyBookingPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const MyBookingPage());
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CancelToken _transactionsCancelToken;
  late CancelToken _historyCancelToken;

  @override
  void initState() {
    super.initState();
    _transactionsCancelToken = CancelToken();
    _historyCancelToken = CancelToken();
    _tabController = TabController(length: 2, vsync: this);

    context
        .read<UserTransactionsCubit>()
        .refresh(ApiConstant.limit, _transactionsCancelToken);
    context
        .read<UserHistoryCubit>()
        .refresh(ApiConstant.limit, _historyCancelToken);
  }

  @override
  void dispose() {
    _transactionsCancelToken.cancel();
    _historyCancelToken.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Transaksi'),
                Tab(text: 'Riwayat'),
              ],
              labelColor: context.adaptiveTertiaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: context.adaptiveTertiaryColor,
              indicatorWeight: 3,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                UserTransactionsInBooking(),
                UserHistoryInBooking(),
              ],
            ),
          ),
        ],
      ),
    ).paddingOnly(top: 32);
  }
}
