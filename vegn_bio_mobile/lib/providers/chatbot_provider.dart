import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/chatbot_service.dart';
import '../services/learning_service.dart';

class ChatbotProvider extends ChangeNotifier {
  final ChatbotService _chatbotService = ChatbotService();
  
  List<ChatMessage> _messages = [];
  List<String> _supportedBreeds = [];
  List<String> _commonSymptoms = [];
  String? _selectedBreed;
  List<String> _selectedSymptoms = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  List<String> get supportedBreeds => _supportedBreeds;
  List<String> get commonSymptoms => _commonSymptoms;
  String? get selectedBreed => _selectedBreed;
  List<String> get selectedSymptoms => _selectedSymptoms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    await loadSupportedBreeds();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: 'welcome',
      text: 'Bonjour ! Je suis votre assistant vétérinaire virtuel. Je peux vous aider à identifier les problèmes de santé de votre animal. Commencez par me dire la race de votre animal.',
      createdAt: DateTime.now(),
      type: MessageType.text,
    );
    _messages.add(welcomeMessage);
    notifyListeners();
  }

  Future<void> loadSupportedBreeds() async {
    try {
      _supportedBreeds = await _chatbotService.getSupportedBreeds();
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> loadCommonSymptoms(String breed) async {
    _setLoading(true);
    try {
      _commonSymptoms = await _chatbotService.getCommonSymptoms(breed);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(String message) async {
    // Ajouter le message de l'utilisateur
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      createdAt: DateTime.now(),
      userId: 'user',
      type: MessageType.text,
    );
    _messages.add(userMessage);
    notifyListeners();

    _setLoading(true);
    try {
      final response = await _chatbotService.sendMessage(message);
      _messages.add(response);
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Ajouter un message d'erreur
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Désolé, une erreur s\'est produite. Veuillez réessayer.',
        createdAt: DateTime.now(),
        type: MessageType.text,
      );
      _messages.add(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getDiagnosis() async {
    if (_selectedBreed == null || _selectedSymptoms.isEmpty) {
      _error = 'Veuillez sélectionner une race et au moins un symptôme';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final diagnosis = await _chatbotService.getVeterinaryDiagnosis(
        animalBreed: _selectedBreed!,
        symptoms: _selectedSymptoms,
      );

      // Sauvegarder la consultation pour l'apprentissage
      await LearningService.saveConsultation(
        animalBreed: _selectedBreed!,
        symptoms: _selectedSymptoms,
        diagnosis: diagnosis.diagnosis ?? 'Diagnostic générique',
        recommendation: diagnosis.recommendation ?? 'Consultez un vétérinaire',
        confidence: diagnosis.confidence,
        userId: 'mobile_user', // Vous pouvez utiliser un ID utilisateur réel
      );

      // Ajouter le diagnostic comme message
      final diagnosisMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: 'Diagnostic: ${diagnosis.diagnosis ?? 'Aucun diagnostic spécifique'}\n\nRecommandations: ${diagnosis.recommendation ?? 'Consultez un vétérinaire'}\n\nConfiance: ${(diagnosis.confidence * 100).toStringAsFixed(1)}%',
        createdAt: DateTime.now(),
        type: MessageType.diagnosis,
        metadata: {
          'confidence': diagnosis.confidence,
          'breed': diagnosis.animalBreed,
          'symptoms': diagnosis.symptoms,
        },
      );
      _messages.add(diagnosisMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void selectBreed(String breed) {
    _selectedBreed = breed;
    _selectedSymptoms.clear();
    loadCommonSymptoms(breed);
    notifyListeners();
  }

  void toggleSymptom(String symptom) {
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _selectedBreed = null;
    _selectedSymptoms.clear();
    _commonSymptoms.clear();
    _addWelcomeMessage();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
