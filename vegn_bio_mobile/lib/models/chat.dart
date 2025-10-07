import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatMessage {
  final String id;
  final String text;
  final DateTime createdAt;
  final String? userId;
  final MessageType type;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.text,
    required this.createdAt,
    this.userId,
    required this.type,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'type': type.toString().split('.').last,
      'metadata': metadata,
    };
  }

  types.Message toFlutterChatMessage() {
    return types.TextMessage(
      id: id,
      text: text,
      author: types.User(id: userId ?? 'bot'),
      createdAt: createdAt.millisecondsSinceEpoch,
      metadata: metadata,
    );
  }
}

enum MessageType {
  text,
  diagnosis,
  symptom,
  breed,
  recommendation,
}

class VeterinaryDiagnosis {
  final String id;
  final String animalBreed;
  final List<String> symptoms;
  final String? diagnosis;
  final String? recommendation;
  final double confidence;
  final DateTime createdAt;

  VeterinaryDiagnosis({
    required this.id,
    required this.animalBreed,
    required this.symptoms,
    this.diagnosis,
    this.recommendation,
    required this.confidence,
    required this.createdAt,
  });

  factory VeterinaryDiagnosis.fromJson(Map<String, dynamic> json) {
    return VeterinaryDiagnosis(
      id: json['id'],
      animalBreed: json['animalBreed'],
      symptoms: List<String>.from(json['symptoms']),
      diagnosis: json['diagnosis'],
      recommendation: json['recommendation'],
      confidence: json['confidence'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animalBreed': animalBreed,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'recommendation': recommendation,
      'confidence': confidence,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
