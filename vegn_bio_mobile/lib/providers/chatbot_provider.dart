import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/chatbot_service.dart';
import '../services/learning_service.dart';
import '../services/conversation_storage_service.dart';
import '../services/recommendation_service.dart';

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
    await loadConversationHistory();
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

  Future<void> loadConversationHistory() async {
    try {
      // Charger l'historique depuis le stockage local
      final localHistory = await ConversationStorageService.getRecentConversations(
        limit: 5,
        userId: 'mobile_user',
      );
      
      // Ajouter les conversations récentes comme messages
      for (final conv in localHistory.reversed) {
        final userMsg = ChatMessage(
          id: '${conv['id']}_user',
          text: conv['userMessage'],
          createdAt: DateTime.parse(conv['timestamp']),
          userId: 'user',
          type: MessageType.text,
        );
        
        final botMsg = ChatMessage(
          id: '${conv['id']}_bot',
          text: conv['botResponse'],
          createdAt: DateTime.parse(conv['timestamp']).add(const Duration(seconds: 1)),
          type: MessageType.text,
        );
        
        _messages.insertAll(0, [userMsg, botMsg]);
      }
      
      // Charger aussi l'historique depuis le serveur si disponible
      final serverHistory = await _chatbotService.getConsultationHistory();
      // Pour l'instant, on se concentre sur le stockage local
      
    } catch (e) {
      // Log l'erreur mais ne pas interrompre l'initialisation
      print('Erreur lors du chargement de l\'historique: $e');
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
      
      // Sauvegarder la conversation dans la base de données
      await _saveConversationToDatabase(userMessage, response);
      
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

  Future<void> _saveConversationToDatabase(ChatMessage userMessage, ChatMessage botMessage) async {
    try {
      // Sauvegarder localement
      await ConversationStorageService.saveConversation(
        userId: 'mobile_user',
        userMessage: userMessage.text,
        botResponse: botMessage.text,
        animalBreed: _selectedBreed ?? 'Non spécifié',
        symptoms: _selectedSymptoms.isNotEmpty ? _selectedSymptoms : ['Question générale'],
      );
      
      // Sauvegarder aussi sur le serveur
      await _chatbotService.saveConsultation(
        animalBreed: _selectedBreed ?? 'Non spécifié',
        symptoms: _selectedSymptoms.isNotEmpty ? _selectedSymptoms : ['Question générale'],
        diagnosis: 'Conversation utilisateur',
        recommendation: botMessage.text,
        userId: 'mobile_user',
      );
    } catch (e) {
      // Log l'erreur mais ne pas interrompre le chat
      print('Erreur lors de la sauvegarde de la conversation: $e');
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

  // Obtenir des recommandations détaillées
  Future<void> getDetailedRecommendations() async {
    if (_selectedBreed == null || _selectedSymptoms.isEmpty) {
      _error = 'Veuillez sélectionner une race et au moins un symptôme';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      // Obtenir les recommandations du service local
      final recommendations = RecommendationService.getRecommendations(
        animalBreed: _selectedBreed!,
        symptoms: _selectedSymptoms,
      );

      // Obtenir les recommandations préventives
      final preventiveRecs = RecommendationService.getPreventiveRecommendations(_selectedBreed!);

      // Obtenir les conseils d'alimentation
      final feedingRecs = RecommendationService.getFeedingRecommendations(_selectedBreed!);

      // Obtenir les conseils comportementaux
      final behavioralRecs = RecommendationService.getBehavioralRecommendations(
        _selectedBreed!, 
        _selectedSymptoms
      );

      // Créer un message de recommandations détaillées
      final recommendationsText = _buildRecommendationsText(
        recommendations,
        preventiveRecs,
        feedingRecs,
        behavioralRecs,
      );

      final recommendationsMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: recommendationsText,
        createdAt: DateTime.now(),
        type: MessageType.recommendation,
        metadata: {
          'breed': _selectedBreed,
          'symptoms': _selectedSymptoms,
          'hasEmergency': _selectedSymptoms.any((symptom) => 
            ['difficultés respiratoires', 'saignement', 'trauma', 'convulsions']
              .any((emergency) => symptom.toLowerCase().contains(emergency.toLowerCase()))
          ),
        },
      );

      _messages.add(recommendationsMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  String _buildRecommendationsText(
    List<String> recommendations,
    List<String> preventiveRecs,
    List<String> feedingRecs,
    List<String> behavioralRecs,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('🐾 **Recommandations détaillées pour ${_selectedBreed}**\n');
    
    if (_selectedSymptoms.any((symptom) => 
      ['difficultés respiratoires', 'saignement', 'trauma', 'convulsions']
        .any((emergency) => symptom.toLowerCase().contains(emergency.toLowerCase()))
    )) {
      buffer.writeln('🚨 **URGENCE DÉTECTÉE**');
      buffer.writeln('Consultez immédiatement un vétérinaire !\n');
    }
    
    buffer.writeln('📋 **Actions immédiates :**');
    for (int i = 0; i < recommendations.length && i < 5; i++) {
      buffer.writeln('• ${recommendations[i]}');
    }
    
    if (preventiveRecs.isNotEmpty) {
      buffer.writeln('\n🛡️ **Prévention pour ${_selectedBreed} :**');
      for (int i = 0; i < preventiveRecs.length && i < 4; i++) {
        buffer.writeln('• ${preventiveRecs[i]}');
      }
    }
    
    if (feedingRecs.isNotEmpty) {
      buffer.writeln('\n🍽️ **Alimentation :**');
      for (int i = 0; i < feedingRecs.length && i < 3; i++) {
        buffer.writeln('• ${feedingRecs[i]}');
      }
    }
    
    if (behavioralRecs.isNotEmpty) {
      buffer.writeln('\n🧠 **Comportement :**');
      for (int i = 0; i < behavioralRecs.length && i < 3; i++) {
        buffer.writeln('• ${behavioralRecs[i]}');
      }
    }
    
    buffer.writeln('\n⚠️ **Important :** Ces recommandations sont à titre informatif. Consultez toujours un vétérinaire pour un diagnostic professionnel.');
    
    return buffer.toString();
  }

  // Obtenir des recommandations préventives
  Future<void> getPreventiveRecommendations() async {
    if (_selectedBreed == null) {
      _error = 'Veuillez sélectionner une race d\'animal';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      final recommendations = RecommendationService.getPreventiveRecommendations(_selectedBreed!);
      
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: '🛡️ **Prévention pour ${_selectedBreed} :**\n\n' + 
              recommendations.map((rec) => '• $rec').join('\n'),
        createdAt: DateTime.now(),
        type: MessageType.recommendation,
      );

      _messages.add(message);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
