import 'package:flutter/material.dart';
import 'package:paint_car/features/home/widgets/user_history_in_booking.dart';
import 'package:paint_car/features/home/widgets/user_transactions_in_booking.dart';
import 'package:paint_car/ui/shared/main_text.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Transactions'),
                Tab(text: 'History'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
            ),
          ),

          // Tab Content
          SizedBox(
            height: MediaQuery.of(context).size.height -
                180, // Sesuaikan ukuran sesuai kebutuhan
            child: TabBarView(
              controller: _tabController,
              children: [
                // Transactions Tab
                const UserTransactionsInBooking(),
                // History Tab
                const UserHistoryInBooking(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
