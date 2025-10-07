package com.vegnbio.restaurant.dto;

import java.time.LocalDateTime;
import java.util.Map;

public record ErrorReportDto(
    Long id,
    String errorType,
    String errorMessage,
    String stackTrace,
    String userId,
    String deviceInfo,
    String appVersion,
    LocalDateTime timestamp,
    String severity,
    String userDescription,
    Map<String, Object> additionalData,
    Boolean resolved
) {}
