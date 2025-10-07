import 'package:uuid/uuid.dart';

class VeterinaryConsultation {
  final String id;
  final String animalBreed;
  final String animalSpecies;
  final int animalAge;
  final String animalGender;
  final List<String> symptoms;
  final String diagnosis;
  final String treatment;
  final String veterinarianName;
  final DateTime consultationDate;
  final double confidence;

  VeterinaryConsultation({
    String? id,
    required this.animalBreed,
    required this.animalSpecies,
    required this.animalAge,
    required this.animalGender,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.veterinarianName,
    required this.consultationDate,
    this.confidence = 0.0,
  }) : id = id ?? const Uuid().v4();

  factory VeterinaryConsultation.fromJson(Map<String, dynamic> json) {
    return VeterinaryConsultation(
      id: json['id'] as String,
      animalBreed: json['animalBreed'] as String,
      animalSpecies: json['animalSpecies'] as String,
      animalAge: json['animalAge'] as int,
      animalGender: json['animalGender'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      diagnosis: json['diagnosis'] as String,
      treatment: json['treatment'] as String,
      veterinarianName: json['veterinarianName'] as String,
      consultationDate: DateTime.parse(json['consultationDate'] as String),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animalBreed': animalBreed,
      'animalSpecies': animalSpecies,
      'animalAge': animalAge,
      'animalGender': animalGender,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'veterinarianName': veterinarianName,
      'consultationDate': consultationDate.toIso8601String(),
      'confidence': confidence,
    };
  }

  String get symptomsText => symptoms.join(', ');
  
  bool matchesSymptoms(List<String> querySymptoms) {
    final queryLower = querySymptoms.map((s) => s.toLowerCase()).toList();
    final consultationLower = symptoms.map((s) => s.toLowerCase()).toList();
    
    int matches = 0;
    for (String querySymptom in queryLower) {
      for (String consultationSymptom in consultationLower) {
        if (consultationSymptom.contains(querySymptom) || 
            querySymptom.contains(consultationSymptom)) {
          matches++;
          break;
        }
      }
    }
    
    return matches >= (querySymptoms.length * 0.5); // Au moins 50% de correspondance
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? animalBreed;
  final List<String>? symptoms;

  ChatMessage({
    String? id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.animalBreed,
    this.symptoms,
  }) : id = id ?? const Uuid().v4();

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      animalBreed: json['animalBreed'] as String?,
      symptoms: json['symptoms'] != null 
          ? List<String>.from(json['symptoms'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'animalBreed': animalBreed,
      'symptoms': symptoms,
    };
  }
}
