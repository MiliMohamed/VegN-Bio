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
      final recommendations = await _chatbotService.getPreventiveRecommendations(_selectedBreed!);
      
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

  // Obtenir des statistiques d'apprentissage
  Future<Map<String, dynamic>> getLearningStatistics() async {
    try {
      return await _chatbotService.getLearningStatistics();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return {};
    }
  }

  // Améliorer le système d'apprentissage
  Future<void> improveLearningSystem({
    required String animalBreed,
    required List<String> symptoms,
    required String diagnosis,
    required String recommendation,
  }) async {
    try {
      await _chatbotService.improveLearning(
        animalBreed: animalBreed,
        symptoms: symptoms,
        diagnosis: diagnosis,
        recommendation: recommendation,
        userId: 'mobile_user',
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Obtenir des recommandations d'urgence
  Future<void> getEmergencyRecommendations() async {
    if (_selectedBreed == null || _selectedSymptoms.isEmpty) {
      _error = 'Veuillez sélectionner une race et au moins un symptôme';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      // Vérifier si c'est une urgence
      final emergencySymptoms = [
        'difficultés respiratoires',
        'saignement',
        'trauma',
        'convulsions',
        'perte de conscience',
        'vomissements persistants',
        'diarrhée avec sang'
      ];

      final isEmergency = _selectedSymptoms.any((symptom) => 
        emergencySymptoms.any((emergency) => 
          symptom.toLowerCase().contains(emergency.toLowerCase())
        )
      );

      String emergencyText;
      if (isEmergency) {
        emergencyText = '''
🚨 **URGENCE VÉTÉRINAIRE DÉTECTÉE** 🚨

⚠️ **Actions immédiates :**
• Contactez immédiatement un vétérinaire d'urgence
• Transportez l'animal avec précaution
• Ne donnez aucun médicament sans avis vétérinaire
• Surveillez les signes vitaux (respiration, pouls)

📞 **Numéros d'urgence :**
• Vétérinaire de garde : [Votre numéro local]
• Centre antipoison vétérinaire : 01 40 68 77 40

🩺 **Symptômes détectés :**
${_selectedSymptoms.map((s) => '• $s').join('\n')}

⏰ **Temps critique :** Consultez dans les 30 minutes maximum
        ''';
      } else {
        emergencyText = '''
✅ **Situation non urgente**

📋 **Recommandations :**
• Surveillez l'évolution des symptômes
• Consultez un vétérinaire dans les 24-48h si les symptômes persistent
• Maintenez l'animal au calme et confortable
• Assurez-vous qu'il reste hydraté

🩺 **Symptômes observés :**
${_selectedSymptoms.map((s) => '• $s').join('\n')}
        ''';
      }

      final emergencyMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: emergencyText,
        createdAt: DateTime.now(),
        type: MessageType.diagnosis,
        metadata: {
          'isEmergency': isEmergency,
          'breed': _selectedBreed,
          'symptoms': _selectedSymptoms,
        },
      );

      _messages.add(emergencyMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Obtenir des conseils d'alimentation spécifiques
  Future<void> getFeedingAdvice() async {
    if (_selectedBreed == null) {
      _error = 'Veuillez sélectionner une race d\'animal';
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      String feedingAdvice;
      
      switch (_selectedBreed!.toLowerCase()) {
        case 'chien':
          feedingAdvice = '''
🍽️ **Conseils d'alimentation pour chien :**

🥩 **Alimentation générale :**
• 2-3 repas par jour pour les adultes
• Aliments riches en protéines animales
• Éviter les os cuits (risque de perforation)
• Surveiller le poids pour éviter l'obésité

🚫 **Aliments toxiques :**
• Chocolat, café, thé
• Oignons, ail, échalotes
• Raisins et raisins secs
• Avocat, noix de macadamia

💧 **Hydratation :**
• Eau fraîche toujours disponible
• Augmenter l'apport en cas de chaleur
• Surveiller la couleur des urines
          ''';
          break;
          
        case 'chat':
          feedingAdvice = '''
🍽️ **Conseils d'alimentation pour chat :**

🐟 **Alimentation générale :**
• Plusieurs petits repas par jour
• Aliments riches en protéines animales
• Taurine essentielle pour la santé cardiaque
• Surveiller les boules de poils

🚫 **Aliments toxiques :**
• Chocolat, café, thé
• Oignons, ail, échalotes
• Raisins et raisins secs
• Lait (intolérance au lactose)

💧 **Hydratation :**
• Les chats boivent peu naturellement
• Aliments humides recommandés
• Fontaines à eau pour encourager la consommation
          ''';
          break;
          
        case 'lapin':
          feedingAdvice = '''
🍽️ **Conseils d'alimentation pour lapin :**

🌿 **Alimentation principale :**
• Foin à volonté (usure des dents)
• Légumes verts frais (2-3 fois par jour)
• Granulés spécifiques lapin (quantité limitée)
• Eau fraîche toujours disponible

🚫 **Aliments interdits :**
• Chocolat, sucreries
• Légumes riches en amidon (pommes de terre)
• Aliments pour autres animaux
• Fruits en excès

🦷 **Santé dentaire :**
• Les dents poussent continuellement
• Foin essentiel pour l'usure
• Surveiller les problèmes de malocclusion
          ''';
          break;
          
        default:
          feedingAdvice = '''
🍽️ **Conseils d'alimentation généraux :**

✅ **Bonnes pratiques :**
• Alimentation adaptée à l'espèce
• Quantités appropriées selon l'âge et le poids
• Eau fraîche toujours disponible
• Éviter les changements brusques d'alimentation

⚠️ **À surveiller :**
• Appétit et consommation d'eau
• Poids et condition physique
• Comportement alimentaire
• Qualité des selles

🩺 **En cas de problème :**
• Consultez un vétérinaire spécialisé
• Ne donnez pas de médicaments sans avis
• Surveillez l'évolution des symptômes
          ''';
      }

      final feedingMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: feedingAdvice,
        createdAt: DateTime.now(),
        type: MessageType.recommendation,
        metadata: {
          'breed': _selectedBreed,
          'category': 'feeding',
        },
      );

      _messages.add(feedingMessage);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
