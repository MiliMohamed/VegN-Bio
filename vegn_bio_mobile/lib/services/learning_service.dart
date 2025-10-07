import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat.dart';

class LearningService {
  static const String baseUrl = 'https://vegn-bio-backend.onrender.com/api/v1';

  /// Sauvegarde une consultation vétérinaire pour l'apprentissage
  static Future<void> saveConsultation({
    required String animalBreed,
    required List<String> symptoms,
    required String diagnosis,
    required String recommendation,
    required double confidence,
    String? userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/consultations'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'animalBreed': animalBreed,
          'symptoms': symptoms,
          'diagnosis': diagnosis,
          'recommendation': recommendation,
          'confidence': confidence,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        print('Consultation sauvegardée avec succès');
      } else {
        print('Erreur lors de la sauvegarde: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde de la consultation: $e');
    }
  }

  /// Récupère l'historique des consultations pour l'apprentissage
  static Future<List<VeterinaryDiagnosis>> getConsultationHistory({String? userId}) async {
    try {
      final uri = userId != null 
          ? Uri.parse('$baseUrl/chatbot/consultations?userId=$userId')
          : Uri.parse('$baseUrl/chatbot/consultations');
          
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => VeterinaryDiagnosis.fromJson(json)).toList();
      } else {
        print('Erreur lors de la récupération de l\'historique: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'historique: $e');
      return [];
    }
  }

  /// Analyse les patterns dans les consultations pour améliorer les diagnostics
  static Future<Map<String, dynamic>> analyzePatterns() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/patterns'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erreur lors de l\'analyse des patterns: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Erreur lors de l\'analyse des patterns: $e');
      return {};
    }
  }
}
