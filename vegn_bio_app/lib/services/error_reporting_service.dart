import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/error_report.dart';

class ErrorReportingService {
  static final ErrorReportingService _instance = ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  static const String _baseUrl = 'https://api.vegnbio.com/reports'; // URL fictive
  final List<ErrorReport> _localReports = [];

  Future<void> reportError({
    required String errorType,
    required String errorMessage,
    required String stackTrace,
    String? userDescription,
    Map<String, dynamic>? additionalData,
    ErrorSeverity severity = ErrorSeverity.medium,
  }) async {
    try {
      final deviceInfo = await _getDeviceInfo();
      final report = ErrorReport(
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        userId: _getUserId(),
        deviceInfo: deviceInfo,
        appVersion: _getAppVersion(),
        timestamp: DateTime.now(),
        severity: severity.value,
        userDescription: userDescription,
        additionalData: additionalData,
      );

      // Ajouter au cache local
      _localReports.add(report);

      // Essayer d'envoyer au serveur
      await _sendToServer(report);
    } catch (e) {
      // En cas d'erreur, sauvegarder localement pour retry plus tard
      // TODO: Log error properly in production
    }
  }

  Future<void> reportCrash({
    required String errorMessage,
    required String stackTrace,
    Map<String, dynamic>? additionalData,
  }) async {
    await reportError(
      errorType: ErrorType.crash.value,
      errorMessage: errorMessage,
      stackTrace: stackTrace,
      additionalData: additionalData,
      severity: ErrorSeverity.critical,
    );
  }

  Future<void> reportNetworkError({
    required String url,
    required int statusCode,
    required String responseBody,
  }) async {
    await reportError(
      errorType: ErrorType.network.value,
      errorMessage: 'Erreur réseau: $statusCode sur $url',
      stackTrace: 'Response: $responseBody',
      additionalData: {
        'url': url,
        'statusCode': statusCode,
        'responseBody': responseBody,
      },
      severity: ErrorSeverity.medium,
    );
  }

  Future<void> reportValidationError({
    required String field,
    required String value,
    required String rule,
  }) async {
    await reportError(
      errorType: ErrorType.validation.value,
      errorMessage: 'Erreur de validation: $field = $value',
      stackTrace: 'Règle violée: $rule',
      additionalData: {
        'field': field,
        'value': value,
        'rule': rule,
      },
      severity: ErrorSeverity.low,
    );
  }

  Future<void> _sendToServer(ErrorReport report) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(report.toJson()),
      );

      if (response.statusCode == 200) {
        // Retirer du cache local après envoi réussi
        _localReports.removeWhere((r) => r.id == report.id);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      // L'erreur sera gérée par le cache local
      rethrow;
    }
  }

  Future<void> retryFailedReports() async {
    final reportsToRetry = List<ErrorReport>.from(_localReports);
    
    for (final report in reportsToRetry) {
      try {
        await _sendToServer(report);
      } catch (e) {
        // Continuer avec les autres rapports
        // TODO: Log retry failure properly
      }
    }
  }

  List<ErrorReport> getLocalReports() {
    return List.unmodifiable(_localReports);
  }

  Future<void> clearLocalReports() async {
    _localReports.clear();
  }

  String _getUserId() {
    // Dans une vraie application, récupérer l'ID utilisateur depuis le système d'authentification
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String> _getDeviceInfo() async {
    try {
      final platform = Platform.operatingSystem;
      final version = Platform.operatingSystemVersion;
      return '$platform $version';
    } catch (e) {
      return 'Unknown device';
    }
  }

  String _getAppVersion() {
    // Dans une vraie application, récupérer depuis pubspec.yaml ou package_info
    return '1.0.0';
  }

  // Méthodes utilitaires pour les logs
  Future<void> logUserAction({
    required String action,
    Map<String, dynamic>? parameters,
  }) async {
    await reportError(
      errorType: 'user_action',
      errorMessage: 'Action utilisateur: $action',
      stackTrace: 'Parameters: ${json.encode(parameters ?? {})}',
      additionalData: {
        'action': action,
        'parameters': parameters,
      },
      severity: ErrorSeverity.low,
    );
  }

  Future<void> logPerformanceIssue({
    required String operation,
    required Duration duration,
    String? details,
  }) async {
    await reportError(
      errorType: 'performance',
      errorMessage: 'Problème de performance: $operation',
      stackTrace: 'Durée: ${duration.inMilliseconds}ms${details != null ? ', Détails: $details' : ''}',
      additionalData: {
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        'details': details,
      },
      severity: duration.inMilliseconds > 5000 ? ErrorSeverity.high : ErrorSeverity.medium,
    );
  }

  // Méthode pour générer un rapport de test
  Future<void> sendTestReport() async {
    await reportError(
      errorType: ErrorType.other.value,
      errorMessage: 'Test de reporting d\'erreur',
      stackTrace: 'Stack trace de test',
      userDescription: 'Ceci est un test du système de reporting',
      severity: ErrorSeverity.low,
    );
  }
}
