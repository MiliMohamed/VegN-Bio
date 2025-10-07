import '../models/veterinary_consultation.dart';

class VeterinaryService {
  static final VeterinaryService _instance = VeterinaryService._internal();
  factory VeterinaryService() => _instance;
  VeterinaryService._internal();

  List<VeterinaryConsultation> _consultations = [];
  final List<ChatMessage> _chatHistory = [];

  // Base de données de démonstration avec des consultations vétérinaires
  static const List<Map<String, dynamic>> _demoConsultations = [
    {
      'id': '1',
      'animalBreed': 'Golden Retriever',
      'animalSpecies': 'Chien',
      'animalAge': 3,
      'animalGender': 'Mâle',
      'symptoms': ['Vomissements', 'Diarrhée', 'Perte d\'appétit', 'Léthargie'],
      'diagnosis': 'Gastro-entérite',
      'treatment': 'Régime alimentaire léger, probiotiques, surveillance',
      'veterinarianName': 'Dr. Martin',
      'consultationDate': '2024-01-15T10:30:00Z',
      'confidence': 0.85
    },
    {
      'id': '2',
      'animalBreed': 'Persan',
      'animalSpecies': 'Chat',
      'animalAge': 7,
      'animalGender': 'Femelle',
      'symptoms': ['Éternuements', 'Écoulement nasal', 'Yeux larmoyants'],
      'diagnosis': 'Rhume des chats',
      'treatment': 'Antibiotiques, nettoyage des yeux, humidification',
      'veterinarianName': 'Dr. Dubois',
      'consultationDate': '2024-01-20T14:15:00Z',
      'confidence': 0.92
    },
    {
      'id': '3',
      'animalBreed': 'Berger Allemand',
      'animalSpecies': 'Chien',
      'animalAge': 5,
      'animalGender': 'Mâle',
      'symptoms': ['Boiterie', 'Douleur articulaire', 'Difficulté à se lever'],
      'diagnosis': 'Dysplasie de la hanche',
      'treatment': 'Anti-inflammatoires, physiothérapie, perte de poids',
      'veterinarianName': 'Dr. Lefebvre',
      'consultationDate': '2024-02-01T09:45:00Z',
      'confidence': 0.88
    },
    {
      'id': '4',
      'animalBreed': 'Siamois',
      'animalSpecies': 'Chat',
      'animalAge': 2,
      'animalGender': 'Femelle',
      'symptoms': ['Vomissements fréquents', 'Perte de poids', 'Soif excessive'],
      'diagnosis': 'Hyperthyroïdie',
      'treatment': 'Médicaments antithyroïdiens, surveillance régulière',
      'veterinarianName': 'Dr. Moreau',
      'consultationDate': '2024-02-10T16:20:00Z',
      'confidence': 0.90
    }
  ];

  Future<void> initializeService() async {
    // Charger les consultations de démonstration
    _consultations = _demoConsultations
        .map((consultation) => VeterinaryConsultation.fromJson(consultation))
        .toList();
  }

  Future<String> getDiagnosis({
    required String animalBreed,
    required String animalSpecies,
    required int animalAge,
    required String animalGender,
    required List<String> symptoms,
  }) async {
    // Simuler un délai de traitement
    await Future.delayed(const Duration(seconds: 2));

    // Rechercher des consultations similaires
    final similarConsultations = _consultations.where((consultation) {
      return consultation.animalSpecies == animalSpecies &&
             consultation.matchesSymptoms(symptoms);
    }).toList();

    if (similarConsultations.isEmpty) {
      return _generateGenericResponse(symptoms);
    }

    // Trouver la consultation la plus similaire
    final bestMatch = similarConsultations.reduce((a, b) {
      final aScore = _calculateSimilarityScore(symptoms, a.symptoms);
      final bScore = _calculateSimilarityScore(symptoms, b.symptoms);
      return aScore > bScore ? a : b;
    });

    final confidence = _calculateSimilarityScore(symptoms, bestMatch.symptoms);
    
    return _formatDiagnosisResponse(bestMatch, confidence);
  }

  double _calculateSimilarityScore(List<String> symptoms1, List<String> symptoms2) {
    final set1 = symptoms1.map((s) => s.toLowerCase()).toSet();
    final set2 = symptoms2.map((s) => s.toLowerCase()).toSet();
    
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);
    
    return union.isEmpty ? 0.0 : intersection.length / union.length;
  }

  String _formatDiagnosisResponse(VeterinaryConsultation consultation, double confidence) {
    final confidencePercent = (confidence * 100).round();
    
    return '''
**Diagnostic probable :** ${consultation.diagnosis}

**Confiance :** $confidencePercent%

**Traitement recommandé :** ${consultation.treatment}

**⚠️ Important :** Cette analyse est basée sur des cas similaires. Il est fortement recommandé de consulter un vétérinaire pour un diagnostic précis et un traitement adapté.

**Consultation de référence :** ${consultation.veterinarianName} (${consultation.consultationDate.day}/${consultation.consultationDate.month}/${consultation.consultationDate.year})
''';
  }

  String _generateGenericResponse(List<String> symptoms) {
    return '''
**Analyse des symptômes :** ${symptoms.join(', ')}

**Recommandation :** Les symptômes décrits nécessitent une consultation vétérinaire urgente. Il est important de ne pas attendre car certains troubles peuvent s'aggraver rapidement.

**Actions immédiates :**
- Surveiller l'animal de près
- Noter l'évolution des symptômes
- Prendre rendez-vous avec un vétérinaire
- En cas d'urgence, contacter le service vétérinaire d'urgence

**⚠️ Avertissement :** Cette application ne remplace pas une consultation vétérinaire professionnelle.
''';
  }

  void addChatMessage(ChatMessage message) {
    _chatHistory.add(message);
  }

  List<ChatMessage> getChatHistory() {
    return List.unmodifiable(_chatHistory);
  }

  void clearChatHistory() {
    _chatHistory.clear();
  }

  Future<void> addConsultation(VeterinaryConsultation consultation) async {
    _consultations.add(consultation);
    // Ici, on pourrait sauvegarder dans une base de données
  }

  List<VeterinaryConsultation> getConsultations() {
    return List.unmodifiable(_consultations);
  }

  List<String> getAvailableBreeds(String species) {
    final breeds = <String>{};
    for (final consultation in _consultations) {
      if (consultation.animalSpecies == species) {
        breeds.add(consultation.animalBreed);
      }
    }
    return breeds.toList()..sort();
  }

  List<String> getAvailableSpecies() {
    final species = <String>{};
    for (final consultation in _consultations) {
      species.add(consultation.animalSpecies);
    }
    return species.toList()..sort();
  }

  List<String> getCommonSymptoms(String species, String breed) {
    final symptoms = <String, int>{};
    
    for (final consultation in _consultations) {
      if (consultation.animalSpecies == species && 
          consultation.animalBreed == breed) {
        for (final symptom in consultation.symptoms) {
          symptoms[symptom] = (symptoms[symptom] ?? 0) + 1;
        }
      }
    }
    
    // Trier par fréquence
    final sortedSymptoms = symptoms.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedSymptoms.map((e) => e.key).toList();
  }
}
