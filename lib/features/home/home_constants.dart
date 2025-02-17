import 'package:paint_car/features/(superadmin)/car/pages/car_brands/car_brands_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_colors/car_colors_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_model_years/car_model_years_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_model_year_color/car_model_year_color_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_models/car_models_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_workshops/car_workshops_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/cars_page.dart';
import 'package:paint_car/features/(superadmin)/car/pages/car_services/car_services_page.dart';
import 'package:paint_car/features/(superadmin)/financial/pages/e_tickets_page.dart';
import 'package:paint_car/features/(superadmin)/financial/pages/history_page.dart';
import 'package:paint_car/features/(superadmin)/financial/pages/orders_page.dart';
import 'package:paint_car/features/(superadmin)/financial/pages/payment_method_page.dart';
import 'package:paint_car/features/(superadmin)/financial/pages/transactions_page.dart';
import 'package:paint_car/features/(user)/financial/pages/user_e_tickets_page.dart';
import 'package:paint_car/features/(user)/financial/pages/user_history_page.dart';
import 'package:paint_car/features/(user)/financial/pages/user_orders_page.dart';
import 'package:paint_car/features/(user)/financial/pages/user_transactions_page.dart';
import 'package:paint_car/features/(user)/other/pages/hubungi_kami_page.dart';
import 'package:paint_car/features/(user)/other/pages/syarat_dan_ketentuan_page.dart';
import 'package:paint_car/features/(user)/other/pages/tentang_aplikasi_page.dart';

class HomeConstants {
  static const List<Map<String, dynamic>> carItemsUser = const [
    {'name': 'Orders', 'route': UserOrdersPage.route},
  ];
  static const List<Map<String, dynamic>> financialItemsUser = const [
    {'name': 'Orders', 'route': UserOrdersPage.route},
    {'name': 'E-Tickets', 'route': UserETicketsPage.route},
    {'name': 'Transactions', 'route': UserTransactionsPage.route},
    {'name': 'History', 'route': UserHistoryPage.route},
  ];
  static const List<Map<String, dynamic>> otherItemsUser = const [
    {'name': 'Hubungi Kami', 'route': HubungiKamiPage.route},
    {'name': 'Syarat Dan Ketentuan', 'route': SyaratDanKetentuanPage.route},
    {'name': 'Tentang Aplikasi', 'route': TentangAplikasiPage.route},
  ];
  static const List<Map<String, dynamic>> carItemsSuperAdmin = const [
    {'name': 'Cars', 'route': CarsPage.route},
    {'name': 'Car Brands', 'route': CarBrandsPage.route},
    {'name': 'Car Models', 'route': CarModelsPage.route},
    {'name': 'Car Services', 'route': CarServicesPage.route},
    {'name': 'Car Workshops', 'route': CarWorkshopsPage.route},
    {'name': 'Car Colors', 'route': CarColorsPage.route},
    {'name': 'Car Model Years', 'route': CarModelYearsPage.route},
    {'name': 'Car Model Years Color', 'route': CarModelYearColorPage.route},
  ];

  static const List<Map<String, dynamic>> financialItemsSuperAdmin = const [
    // TODO: HANYA GET UNTUK ADMIN
    {'name': 'Orders', 'route': OrdersPage.route},
    {'name': 'Transactions', 'route': TransactionsPage.route},
    {'name': 'E-Tickets', 'route': ETicketsPage.route},
    {'name': 'Payment Methods', 'route': PaymentMethodPage.route},
    {'name': 'History', 'route': HistoryPage.route},
  ];
}
