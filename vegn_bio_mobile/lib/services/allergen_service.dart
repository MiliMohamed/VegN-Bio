import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../models/allergen.dart';

class AllergenService {
  static final AllergenService _instance = AllergenService._internal();
  factory AllergenService() => _instance;
  AllergenService._internal();

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

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => _logger.d(obj),
    ));
  }

  Future<List<Allergen>> getAllAllergens() async {
    try {
      final response = await _dio.get('/allergens');
      final List<dynamic> data = response.data;
      return data.map((json) => Allergen.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la récupération des allergènes: $e');
      rethrow;
    }
  }

  Future<Allergen> getAllergenByCode(String code) async {
    try {
      final response = await _dio.get('/allergens/$code');
      return Allergen.fromJson(response.data);
    } catch (e) {
      _logger.e('Erreur lors de la récupération de l\'allergène $code: $e');
      rethrow;
    }
  }

  // Méthode pour vérifier si un menu contient des allergènes spécifiques
  Future<bool> checkMenuAllergens(int menuId, List<String> allergenCodes) async {
    try {
      final response = await _dio.post('/allergens/check-menu', data: {
        'menuId': menuId,
        'allergenCodes': allergenCodes,
      });
      return response.data['containsAllergens'] ?? false;
    } catch (e) {
      _logger.e('Erreur lors de la vérification des allergènes du menu $menuId: $e');
      rethrow;
    }
  }
}
