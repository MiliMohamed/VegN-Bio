import 'package:flutter/foundation.dart';
import '../models/veterinary_consultation.dart';
import '../services/veterinary_service.dart';

class VeterinaryProvider with ChangeNotifier {
  final VeterinaryService _veterinaryService = VeterinaryService();
  
  List<ChatMessage> _chatHistory = [];
  List<String> _availableSpecies = [];
  List<String> _availableBreeds = [];
  List<String> _commonSymptoms = [];
  String _selectedSpecies = '';
  String _selectedBreed = '';
  String _animalGender = 'Mâle';
  int _animalAge = 1;
  List<String> _selectedSymptoms = [];
  bool _isLoading = false;
  bool _isDiagnosing = false;
  String? _error;
  String? _lastDiagnosis;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  List<String> get availableSpecies => _availableSpecies;
  List<String> get availableBreeds => _availableBreeds;
  List<String> get commonSymptoms => _commonSymptoms;
  String get selectedSpecies => _selectedSpecies;
  String get selectedBreed => _selectedBreed;
  String get animalGender => _animalGender;
  int get animalAge => _animalAge;
  List<String> get selectedSymptoms => _selectedSymptoms;
  bool get isLoading => _isLoading;
  bool get isDiagnosing => _isDiagnosing;
  String? get error => _error;
  String? get lastDiagnosis => _lastDiagnosis;

  Future<void> initializeService() async {
    _setLoading(true);
    _clearError();

    try {
      await _veterinaryService.initializeService();
      _availableSpecies = _veterinaryService.getAvailableSpecies();
      _loadInitialMessage();
    } catch (e) {
      _setError('Erreur lors de l\'initialisation: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _loadInitialMessage() {
    final welcomeMessage = ChatMessage(
      content: '''
🐾 Bienvenue dans l'assistant vétérinaire !

Je suis là pour vous aider à analyser les symptômes de votre animal. Pour commencer, pouvez-vous me dire :

1. **Quel est l'espèce de votre animal ?** (Chien, Chat, etc.)
2. **Quelle est sa race ?**
3. **Quels sont les symptômes observés ?**

⚠️ **Important :** Cette application ne remplace pas une consultation vétérinaire professionnelle. En cas d'urgence, contactez immédiatement un vétérinaire.
''',
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    _chatHistory = [welcomeMessage];
    notifyListeners();
  }

  void setSpecies(String species) {
    _selectedSpecies = species;
    _selectedBreed = '';
    _selectedSymptoms.clear();
    _availableBreeds = _veterinaryService.getAvailableBreeds(species);
    _commonSymptoms = [];
    _addSystemMessage('Espèce sélectionnée : $species');
    notifyListeners();
  }

  void setBreed(String breed) {
    _selectedBreed = breed;
    _selectedSymptoms.clear();
    _commonSymptoms = _veterinaryService.getCommonSymptoms(_selectedSpecies, breed);
    _addSystemMessage('Race sélectionnée : $breed');
    notifyListeners();
  }

  void setAnimalGender(String gender) {
    _animalGender = gender;
    notifyListeners();
  }

  void setAnimalAge(int age) {
    _animalAge = age;
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

  void addCustomSymptom(String symptom) {
    if (symptom.trim().isNotEmpty && !_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.add(symptom.trim());
      notifyListeners();
    }
  }

  void removeSymptom(String symptom) {
    _selectedSymptoms.remove(symptom);
    notifyListeners();
  }

  Future<void> requestDiagnosis() async {
    if (_selectedSpecies.isEmpty || _selectedSymptoms.isEmpty) {
      _setError('Veuillez sélectionner au moins l\'espèce et les symptômes');
      return;
    }

    _setDiagnosing(true);
    _clearError();

    // Ajouter le message utilisateur
    final userMessage = ChatMessage(
      content: _formatUserRequest(),
      isUser: true,
      timestamp: DateTime.now(),
      animalBreed: _selectedBreed,
      symptoms: List.from(_selectedSymptoms),
    );
    
    _chatHistory.add(userMessage);

    try {
      final diagnosis = await _veterinaryService.getDiagnosis(
        animalBreed: _selectedBreed,
        animalSpecies: _selectedSpecies,
        animalAge: _animalAge,
        animalGender: _animalGender,
        symptoms: _selectedSymptoms,
      );

      _lastDiagnosis = diagnosis;

      final botMessage = ChatMessage(
        content: diagnosis,
        isUser: false,
        timestamp: DateTime.now(),
      );

      _chatHistory.add(botMessage);
      
      // Sauvegarder dans l'historique du service
      _veterinaryService.addChatMessage(userMessage);
      _veterinaryService.addChatMessage(botMessage);

    } catch (e) {
      _setError('Erreur lors du diagnostic: $e');
      
      final errorMessage = ChatMessage(
        content: 'Désolé, une erreur s\'est produite lors de l\'analyse. Veuillez réessayer.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      
      _chatHistory.add(errorMessage);
    } finally {
      _setDiagnosing(false);
    }
  }

  String _formatUserRequest() {
    final buffer = StringBuffer();
    buffer.writeln('**Informations sur l\'animal :**');
    buffer.writeln('- Espèce : $_selectedSpecies');
    if (_selectedBreed.isNotEmpty) buffer.writeln('- Race : $_selectedBreed');
    buffer.writeln('- Âge : $_animalAge an${_animalAge > 1 ? 's' : ''}');
    buffer.writeln('- Sexe : $_animalGender');
    buffer.writeln();
    buffer.writeln('**Symptômes observés :**');
    for (final symptom in _selectedSymptoms) {
      buffer.writeln('- $symptom');
    }
    
    return buffer.toString();
  }

  void _addSystemMessage(String message) {
    final systemMessage = ChatMessage(
      content: message,
      isUser: false,
      timestamp: DateTime.now(),
    );
    _chatHistory.add(systemMessage);
  }

  void clearChat() {
    _chatHistory.clear();
    _selectedSpecies = '';
    _selectedBreed = '';
    _selectedSymptoms.clear();
    _availableBreeds.clear();
    _commonSymptoms.clear();
    _lastDiagnosis = null;
    _loadInitialMessage();
  }

  void resetAnimalInfo() {
    _selectedSpecies = '';
    _selectedBreed = '';
    _selectedSymptoms.clear();
    _availableBreeds.clear();
    _commonSymptoms.clear();
    _animalGender = 'Mâle';
    _animalAge = 1;
    _lastDiagnosis = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setDiagnosing(bool diagnosing) {
    _isDiagnosing = diagnosing;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  bool get canRequestDiagnosis {
    return _selectedSpecies.isNotEmpty && _selectedSymptoms.isNotEmpty;
  }

  bool get hasCompleteAnimalInfo {
    return _selectedSpecies.isNotEmpty && 
           _selectedBreed.isNotEmpty && 
           _animalAge > 0;
  }

  /// Ajoute un message au chat
  void addChatMessage(ChatMessage message) {
    _chatHistory.add(message);
    notifyListeners();
  }
}
