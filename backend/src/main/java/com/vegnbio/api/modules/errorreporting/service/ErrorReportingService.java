package com.vegnbio.api.modules.errorreporting.service;

import com.vegnbio.api.modules.errorreporting.dto.*;
import com.vegnbio.api.modules.errorreporting.entity.ErrorReport;
import com.vegnbio.api.modules.errorreporting.repo.ErrorReportRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ErrorReportingService {
    
    private final ErrorReportRepository errorReportRepository;
    
    public void reportError(ErrorReportRequest request) {
        log.info("Reporting error: {} - {}", request.getErrorType(), request.getErrorMessage());
        
        try {
            ErrorReport errorReport = ErrorReport.builder()
                    .errorType(request.getErrorType())
                    .errorMessage(request.getErrorMessage())
                    .stackTrace(request.getStackTrace())
                    .userId(request.getUserId())
                    .deviceInfo(request.getDeviceInfo())
                    .appVersion(request.getAppVersion())
                    .timestamp(LocalDateTime.now())
                    .additionalData(convertAdditionalData(request.getAdditionalData()))
                    .build();
            
            errorReportRepository.save(errorReport);
            log.info("Error report saved successfully with ID: {}", errorReport.getId());
            
        } catch (Exception e) {
            log.error("Failed to save error report: {}", e.getMessage(), e);
        }
    }
    
    public List<ErrorReportDto> getErrorReports(String userId) {
        List<ErrorReport> reports = errorReportRepository.findByUserIdOrderByTimestampDesc(userId);
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<ErrorReportDto> getErrorReportsByType(String errorType) {
        List<ErrorReport> reports = errorReportRepository.findByErrorTypeOrderByTimestampDesc(errorType);
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<ErrorReportDto> getErrorReportsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<ErrorReport> reports = errorReportRepository.findByTimestampBetweenOrderByTimestampDesc(startDate, endDate);
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public ErrorStatisticsDto getErrorStatistics(LocalDateTime startDate, LocalDateTime endDate) {
        Long totalErrors = errorReportRepository.countErrorsByDateRange(startDate, endDate);
        
        List<Object[]> errorTypeCount = errorReportRepository.countErrorsByType();
        List<Object[]> userErrorCount = errorReportRepository.countErrorsByUser();
        List<Object[]> deviceErrorCount = errorReportRepository.countErrorsByDevice();
        
        Map<String, Long> errorTypeMap = errorTypeCount.stream()
                .collect(Collectors.toMap(
                        row -> (String) row[0],
                        row -> (Long) row[1]
                ));
        
        Map<String, Long> userErrorMap = userErrorCount.stream()
                .collect(Collectors.toMap(
                        row -> (String) row[0],
                        row -> (Long) row[1]
                ));
        
        Map<String, Long> deviceErrorMap = deviceErrorCount.stream()
                .collect(Collectors.toMap(
                        row -> (String) row[0],
                        row -> (Long) row[1]
                ));
        
        return ErrorStatisticsDto.builder()
                .totalErrors(totalErrors)
                .errorTypeCount(errorTypeMap)
                .userErrorCount(userErrorMap)
                .deviceErrorCount(deviceErrorMap)
                .build();
    }
    
    public void cleanupOldReports(int daysToKeep) {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(daysToKeep);
        List<ErrorReport> oldReports = errorReportRepository.findByTimestampBetweenOrderByTimestampDesc(
                LocalDateTime.of(2020, 1, 1, 0, 0), cutoffDate);
        
        errorReportRepository.deleteAll(oldReports);
        log.info("Cleaned up {} old error reports", oldReports.size());
    }
    
    private Map<String, String> convertAdditionalData(Map<String, Object> additionalData) {
        if (additionalData == null) {
            return new HashMap<>();
        }
        
        return additionalData.entrySet().stream()
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue() != null ? entry.getValue().toString() : ""
                ));
    }
    
    private ErrorReportDto convertToDto(ErrorReport errorReport) {
        return ErrorReportDto.builder()
                .id(errorReport.getId().toString())
                .errorType(errorReport.getErrorType())
                .errorMessage(errorReport.getErrorMessage())
                .stackTrace(errorReport.getStackTrace())
                .userId(errorReport.getUserId())
                .deviceInfo(errorReport.getDeviceInfo())
                .appVersion(errorReport.getAppVersion())
                .timestamp(errorReport.getTimestamp())
                .additionalData(errorReport.getAdditionalData())
                .build();
    }
}
