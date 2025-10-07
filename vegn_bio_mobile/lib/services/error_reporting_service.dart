import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/error_report.dart';

class ErrorReportingService {
  static final ErrorReportingService _instance = ErrorReportingService._internal();
  factory ErrorReportingService() => _instance;
  ErrorReportingService._internal();

  late Dio _dio;
  final Logger _logger = Logger();
  final Uuid _uuid = const Uuid();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['ERROR_REPORTING_URL'] ?? 'http://localhost:8080/api/v1/errors',
      connectTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
      receiveTimeout: Duration(milliseconds: int.parse(dotenv.env['API_TIMEOUT'] ?? '30000')),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => _logger.d(obj),
    ));
  }

  // Signaler une erreur
  Future<void> reportError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    String? userId,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Vérifier si le reporting d'erreurs est activé
      if (dotenv.env['ERROR_REPORTING_ENABLED']?.toLowerCase() != 'true') {
        _logger.d('Reporting d\'erreurs désactivé');
        return;
      }

      final deviceInfo = await _getDeviceInfo();
      final packageInfo = await PackageInfo.fromPlatform();

      final errorReport = ErrorReport(
        id: _uuid.v4(),
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        userId: userId,
        deviceInfo: deviceInfo,
        appVersion: packageInfo.version,
        timestamp: DateTime.now(),
        additionalData: additionalData,
      );

      await _dio.post('/report', data: errorReport.toJson());
      _logger.d('Erreur signalée avec succès: ${errorReport.id}');
    } catch (e) {
      _logger.e('Erreur lors du signalement d\'erreur: $e');
      // Ne pas relancer l'erreur pour éviter les boucles infinies
    }
  }

  // Signaler une erreur d'API
  Future<void> reportApiError({
    required String endpoint,
    required int statusCode,
    required String errorMessage,
    String? userId,
    Map<String, dynamic>? requestData,
  }) async {
    await reportError(
      errorType: 'API_ERROR',
      errorMessage: 'API Error: $endpoint - $statusCode - $errorMessage',
      userId: userId,
      additionalData: {
        'endpoint': endpoint,
        'statusCode': statusCode,
        'requestData': requestData,
      },
    );
  }

  // Signaler une erreur de chatbot
  Future<void> reportChatbotError({
    required String errorMessage,
    String? userId,
    String? animalBreed,
    List<String>? symptoms,
  }) async {
    await reportError(
      errorType: 'CHATBOT_ERROR',
      errorMessage: errorMessage,
      userId: userId,
      additionalData: {
        'animalBreed': animalBreed,
        'symptoms': symptoms,
      },
    );
  }

  // Signaler une erreur de navigation
  Future<void> reportNavigationError({
    required String route,
    required String errorMessage,
    String? userId,
  }) async {
    await reportError(
      errorType: 'NAVIGATION_ERROR',
      errorMessage: 'Navigation Error: $route - $errorMessage',
      userId: userId,
      additionalData: {
        'route': route,
      },
    );
  }

  // Obtenir les informations du dispositif
  Future<String> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release} - ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion} - ${iosInfo.model}';
      } else {
        return 'Unknown Platform';
      }
    } catch (e) {
      _logger.e('Erreur lors de la récupération des informations du dispositif: $e');
      return 'Unknown Device';
    }
  }

  // Obtenir les statistiques d'erreurs (pour les administrateurs)
  Future<Map<String, dynamic>> getErrorStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get('/statistics', queryParameters: queryParams);
      return response.data;
    } catch (e) {
      _logger.e('Erreur lors de la récupération des statistiques d\'erreurs: $e');
      rethrow;
    }
  }
}
