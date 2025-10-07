import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../models/menu.dart';
import '../models/restaurant.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final Logger _logger = Logger();

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8080/api/v1',
      connectTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
      receiveTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Intercepteur pour les logs
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => _logger.d(obj),
    ));
  }

  // Méthodes pour les restaurants
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _dio.get('/restaurants');
      final List<dynamic> data = response.data;
      return data.map((json) => Restaurant.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la récupération des restaurants: $e');
      rethrow;
    }
  }

  Future<Restaurant> getRestaurant(int id) async {
    try {
      final response = await _dio.get('/restaurants/$id');
      return Restaurant.fromJson(response.data);
    } catch (e) {
      _logger.e('Erreur lors de la récupération du restaurant $id: $e');
      rethrow;
    }
  }

  // Méthodes pour les menus
  Future<List<Menu>> getMenusByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get('/menus/restaurant/$restaurantId');
      final List<dynamic> data = response.data;
      return data.map((json) => Menu.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la récupération des menus du restaurant $restaurantId: $e');
      rethrow;
    }
  }

  Future<List<Menu>> getActiveMenusByRestaurant(int restaurantId, {DateTime? date}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) {
        queryParams['date'] = date.toIso8601String().split('T')[0];
      }
      
      final response = await _dio.get(
        '/menus/restaurant/$restaurantId/active',
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Menu.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la récupération des menus actifs du restaurant $restaurantId: $e');
      rethrow;
    }
  }

  Future<Menu> getMenu(int menuId) async {
    try {
      final response = await _dio.get('/menus/$menuId');
      return Menu.fromJson(response.data);
    } catch (e) {
      _logger.e('Erreur lors de la récupération du menu $menuId: $e');
      rethrow;
    }
  }

  // Méthode pour rechercher des menus par allergènes
  Future<List<Menu>> searchMenusByAllergens(List<String> allergens) async {
    try {
      final response = await _dio.post('/menus/search', data: {
        'allergens': allergens,
      });
      final List<dynamic> data = response.data;
      return data.map((json) => Menu.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la recherche de menus par allergènes: $e');
      rethrow;
    }
  }
}
