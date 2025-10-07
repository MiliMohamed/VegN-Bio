import 'package:uuid/uuid.dart';

class ErrorReport {
  final String id;
  final String errorType;
  final String errorMessage;
  final String stackTrace;
  final String userId;
  final String deviceInfo;
  final String appVersion;
  final DateTime timestamp;
  final String severity;
  final String? userDescription;
  final Map<String, dynamic>? additionalData;

  ErrorReport({
    String? id,
    required this.errorType,
    required this.errorMessage,
    required this.stackTrace,
    required this.userId,
    required this.deviceInfo,
    required this.appVersion,
    required this.timestamp,
    this.severity = 'medium',
    this.userDescription,
    this.additionalData,
  }) : id = id ?? const Uuid().v4();

  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      id: json['id'] as String,
      errorType: json['errorType'] as String,
      errorMessage: json['errorMessage'] as String,
      stackTrace: json['stackTrace'] as String,
      userId: json['userId'] as String,
      deviceInfo: json['deviceInfo'] as String,
      appVersion: json['appVersion'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      severity: json['severity'] as String? ?? 'medium',
      userDescription: json['userDescription'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'errorType': errorType,
      'errorMessage': errorMessage,
      'stackTrace': stackTrace,
      'userId': userId,
      'deviceInfo': deviceInfo,
      'appVersion': appVersion,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'userDescription': userDescription,
      'additionalData': additionalData,
    };
  }

  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} à ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

enum ErrorSeverity {
  low('low', 'Faible'),
  medium('medium', 'Moyen'),
  high('high', 'Élevé'),
  critical('critical', 'Critique');

  const ErrorSeverity(this.value, this.displayName);
  final String value;
  final String displayName;
}

enum ErrorType {
  network('network', 'Réseau'),
  database('database', 'Base de données'),
  ui('ui', 'Interface utilisateur'),
  api('api', 'API'),
  crash('crash', 'Plantage'),
  validation('validation', 'Validation'),
  authentication('authentication', 'Authentification'),
  other('other', 'Autre');

  const ErrorType(this.value, this.displayName);
  final String value;
  final String displayName;
}
