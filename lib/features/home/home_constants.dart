import 'package:paint_car/features/car/pages/car_brands/car_brands_page.dart';
import 'package:paint_car/features/car/pages/car_models/car_models_page.dart';
import 'package:paint_car/features/car/pages/cars_page.dart';
import 'package:paint_car/features/car/pages/car_services/cars_services_page.dart';
import 'package:paint_car/features/users/pages/profile_page.dart';
import 'package:paint_car/features/users/pages/users_page.dart';

class HomeConstants {
  static const List<Map<String, dynamic>> carItems = const [
    {'name': 'Cars', 'route': CarsPage.route},
    {'name': 'Car Brands', 'route': CarBrandsPage.route},
    {'name': 'Car Models', 'route': CarModelsPage.route},
    {'name': 'Car Services', 'route': CarsServicesPage.route},
  ];

  static const List<Map<String, dynamic>> userItems = const [
    {'name': 'Users', 'route': UsersPage.route},
    {'name': 'Profile', 'route': ProfilePage.route},
  ];
}
