import 'package:paint_car/features/car/pages/car_brands/car_brands_page.dart';
import 'package:paint_car/features/car/pages/car_colors/car_colors_page.dart';
import 'package:paint_car/features/car/pages/car_model_years/car_model_years_page.dart';
import 'package:paint_car/features/car/pages/car_model_year_color/car_model_year_color_page.dart';
import 'package:paint_car/features/car/pages/car_models/car_models_page.dart';
import 'package:paint_car/features/car/pages/car_workshops/car_workshops_page.dart';
import 'package:paint_car/features/car/pages/cars_page.dart';
import 'package:paint_car/features/car/pages/car_services/car_services_page.dart';
import 'package:paint_car/features/financial/pages/e_tickets_page.dart';
import 'package:paint_car/features/financial/pages/orders_page.dart';
import 'package:paint_car/features/financial/pages/payment_method_page.dart';
import 'package:paint_car/features/financial/pages/transactions_page.dart';
import 'package:paint_car/features/users/pages/profile_page.dart';
import 'package:paint_car/features/users/pages/users_page.dart';

class HomeConstants {
  static const List<Map<String, dynamic>> carItems = const [
    {'name': 'Cars', 'route': CarsPage.route},
    {'name': 'Car Brands', 'route': CarBrandsPage.route},
    {'name': 'Car Models', 'route': CarModelsPage.route},
    {'name': 'Car Services', 'route': CarServicesPage.route},
    // TODO: SEMUA YANG ROUTE NYA MASIH GAJELAS LAKUIN
    {'name': 'Car Workshops', 'route': CarWorkshopsPage.route},
    {'name': 'Car Colors', 'route': CarColorsPage.route},
    {'name': 'Car Model Years', 'route': CarModelYearsPage.route},
    {'name': 'Car Model Years Color', 'route': CarModelYearColorPage.route},
  ];

  static const List<Map<String, dynamic>> userItems = const [
    {'name': 'Users', 'route': UsersPage.route},
    {'name': 'Profile', 'route': ProfilePage.route},
  ];
  static const List<Map<String, dynamic>> financialItems = const [
    // TODO: HANYA GET UNTUK ADMIN
    {'name': 'Orders', 'route': OrdersPage.route},
    {'name': 'Transactions', 'route': TransactionsPage.route},
    {'name': 'E-Tickets', 'route': ETicketsPage.route},
    {'name': 'Payment Methods', 'route': PaymentMethodPage.route},
  ];
}
