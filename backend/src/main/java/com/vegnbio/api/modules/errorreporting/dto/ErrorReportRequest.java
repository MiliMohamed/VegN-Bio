package com.vegnbio.api.modules.errorreporting.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ErrorReportRequest {
    
    private String id;
    private String errorType;
    private String errorMessage;
    private String stackTrace;
    private String userId;
    private String deviceInfo;
    private String appVersion;
    private String timestamp;
    private Map<String, Object> additionalData;
}
