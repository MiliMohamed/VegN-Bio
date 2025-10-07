class ErrorReport {
  final String id;
  final String errorType;
  final String errorMessage;
  final String? stackTrace;
  final String? userId;
  final String? deviceInfo;
  final String? appVersion;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;

  ErrorReport({
    required this.id,
    required this.errorType,
    required this.errorMessage,
    this.stackTrace,
    this.userId,
    this.deviceInfo,
    this.appVersion,
    required this.timestamp,
    this.additionalData,
  });

  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      id: json['id'],
      errorType: json['errorType'],
      errorMessage: json['errorMessage'],
      stackTrace: json['stackTrace'],
      userId: json['userId'],
      deviceInfo: json['deviceInfo'],
      appVersion: json['appVersion'],
      timestamp: DateTime.parse(json['timestamp']),
      additionalData: json['additionalData'],
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
      'additionalData': additionalData,
    };
  }
}
