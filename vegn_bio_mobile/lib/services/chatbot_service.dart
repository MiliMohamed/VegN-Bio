import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../models/chat.dart';

class ChatbotService {
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  late Dio _dio;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['CHATBOT_API_URL'] ?? 'http://localhost:8080/api/v1/chatbot',
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

  // Envoyer un message au chatbot
  Future<ChatMessage> sendMessage(String message, {String? userId}) async {
    try {
      final response = await _dio.post('/chat', data: {
        'message': message,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return ChatMessage.fromJson(response.data);
    } catch (e) {
      _logger.e('Erreur lors de l\'envoi du message au chatbot: $e');
      rethrow;
    }
  }

  // Obtenir un diagnostic vétérinaire
  Future<VeterinaryDiagnosis> getVeterinaryDiagnosis({
    required String animalBreed,
    required List<String> symptoms,
    String? userId,
  }) async {
    try {
      final response = await _dio.post('/diagnosis', data: {
        'animalBreed': animalBreed,
        'symptoms': symptoms,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return VeterinaryDiagnosis.fromJson(response.data);
    } catch (e) {
      _logger.e('Erreur lors de l\'obtention du diagnostic vétérinaire: $e');
      rethrow;
    }
  }

  // Obtenir des recommandations basées sur les symptômes
  Future<List<String>> getRecommendations({
    required String animalBreed,
    required List<String> symptoms,
    String? userId,
  }) async {
    try {
      final response = await _dio.post('/recommendations', data: {
        'animalBreed': animalBreed,
        'symptoms': symptoms,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return List<String>.from(response.data['recommendations']);
    } catch (e) {
      _logger.e('Erreur lors de l\'obtention des recommandations: $e');
      rethrow;
    }
  }

  // Sauvegarder une consultation pour l'apprentissage
  Future<void> saveConsultation({
    required String animalBreed,
    required List<String> symptoms,
    required String diagnosis,
    required String recommendation,
    String? userId,
  }) async {
    try {
      await _dio.post('/consultations', data: {
        'animalBreed': animalBreed,
        'symptoms': symptoms,
        'diagnosis': diagnosis,
        'recommendation': recommendation,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      _logger.e('Erreur lors de la sauvegarde de la consultation: $e');
      rethrow;
    }
  }

  // Obtenir l'historique des consultations
  Future<List<VeterinaryDiagnosis>> getConsultationHistory({String? userId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) {
        queryParams['userId'] = userId;
      }

      final response = await _dio.get('/consultations', queryParameters: queryParams);
      final List<dynamic> data = response.data;
      return data.map((json) => VeterinaryDiagnosis.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Erreur lors de la récupération de l\'historique des consultations: $e');
      rethrow;
    }
  }

  // Obtenir les races d'animaux supportées
  Future<List<String>> getSupportedBreeds() async {
    try {
      final response = await _dio.get('/breeds');
      return List<String>.from(response.data['breeds']);
    } catch (e) {
      _logger.e('Erreur lors de la récupération des races supportées: $e');
      rethrow;
    }
  }

  // Obtenir les symptômes communs pour une race
  Future<List<String>> getCommonSymptoms(String breed) async {
    try {
      final response = await _dio.get('/symptoms/$breed');
      return List<String>.from(response.data['symptoms']);
    } catch (e) {
      _logger.e('Erreur lors de la récupération des symptômes pour $breed: $e');
      rethrow;
    }
  }
}
