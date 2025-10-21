package com.vegnbio.api.modules.errorreporting.service;

import com.vegnbio.api.modules.errorreporting.dto.ErrorReportDto;
import com.vegnbio.api.modules.errorreporting.dto.CreateErrorReportRequest;
import com.vegnbio.api.modules.errorreporting.entity.ErrorReport;
import com.vegnbio.api.modules.errorreporting.entity.ErrorSeverity;
import com.vegnbio.api.modules.errorreporting.entity.ErrorStatus;
import com.vegnbio.api.modules.errorreporting.repo.ErrorReportRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ErrorReportingService {
    
    private static final Logger log = LoggerFactory.getLogger(ErrorReportingService.class);
    private final ErrorReportRepository errorReportRepository;
    
    @Transactional
    public ErrorReportDto createErrorReport(CreateErrorReportRequest request) {
        log.info("Creating error report: {}", request.getTitle());
        
        ErrorReport errorReport = ErrorReport.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .errorType(request.getErrorType())
                .severity(ErrorSeverity.valueOf(request.getSeverity()))
                .status(ErrorStatus.OPEN)
                .userAgent(request.getUserAgent())
                .url(request.getUrl())
                .stackTrace(request.getStackTrace())
                .userId(request.getUserId())
                .createdAt(LocalDateTime.now())
                .build();
        
        errorReportRepository.save(errorReport);
        
        // Log pour monitoring
        log.error("Error reported: {} - {}", request.getTitle(), request.getDescription());
        
        return convertToDto(errorReport);
    }
    
    @Transactional(readOnly = true)
    public List<ErrorReportDto> getAllErrorReports(String status, String severity) {
        List<ErrorReport> reports;
        
        if (status != null && severity != null) {
            reports = errorReportRepository.findByStatusAndSeverity(
                ErrorStatus.valueOf(status.toUpperCase()),
                ErrorSeverity.valueOf(severity.toUpperCase())
            );
        } else if (status != null) {
            reports = errorReportRepository.findByStatus(ErrorStatus.valueOf(status.toUpperCase()));
        } else if (severity != null) {
            reports = errorReportRepository.findBySeverity(ErrorSeverity.valueOf(severity.toUpperCase()));
        } else {
            reports = errorReportRepository.findAll();
        }
        
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public ErrorReportDto getErrorReportById(Long id) {
        ErrorReport report = errorReportRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Error report not found"));
        return convertToDto(report);
    }
    
    @Transactional(readOnly = true)
    public Map<String, Object> getErrorStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        long totalErrors = errorReportRepository.count();
        long openErrors = errorReportRepository.countByStatus(ErrorStatus.OPEN);
        long resolvedErrors = errorReportRepository.countByStatus(ErrorStatus.RESOLVED);
        
        // Statistiques par sévérité
        Map<String, Long> severityStats = new HashMap<>();
        for (ErrorSeverity severity : ErrorSeverity.values()) {
            long count = errorReportRepository.countBySeverity(severity);
            severityStats.put(severity.name(), count);
        }
        
        // Statistiques par type d'erreur
        List<Object[]> errorTypeStatsRaw = errorReportRepository.findErrorTypeStatistics();
        Map<String, Long> errorTypeStats = new HashMap<>();
        for (Object[] row : errorTypeStatsRaw) {
            errorTypeStats.put((String) row[0], (Long) row[1]);
        }
        
        // Erreurs récentes (24h)
        LocalDateTime yesterday = LocalDateTime.now().minusHours(24);
        long recentErrors = errorReportRepository.countByCreatedAtAfter(yesterday);
        
        stats.put("totalErrors", totalErrors);
        stats.put("openErrors", openErrors);
        stats.put("resolvedErrors", resolvedErrors);
        stats.put("severityStats", severityStats);
        stats.put("errorTypeStats", errorTypeStats);
        stats.put("recentErrors24h", recentErrors);
        stats.put("resolutionRate", totalErrors > 0 ? (double) resolvedErrors / totalErrors : 0.0);
        
        return stats;
    }
    
    @Transactional(readOnly = true)
    public List<ErrorReportDto> getRecentErrors(int hours) {
        LocalDateTime since = LocalDateTime.now().minusHours(hours);
        List<ErrorReport> reports = errorReportRepository.findByCreatedAtAfterOrderByCreatedAtDesc(since);
        
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public ErrorReportDto updateErrorStatus(Long id, String status) {
        ErrorReport report = errorReportRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Error report not found"));
        
        report.setStatus(ErrorStatus.valueOf(status.toUpperCase()));
        report.setUpdatedAt(LocalDateTime.now());
        
        errorReportRepository.save(report);
        
        log.info("Error report {} status updated to {}", id, status);
        
        return convertToDto(report);
    }
    
    @Transactional
    public Map<String, Object> createBulkErrorReports(List<CreateErrorReportRequest> requests) {
        List<ErrorReportDto> createdReports = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        
        for (CreateErrorReportRequest request : requests) {
            try {
                ErrorReportDto report = createErrorReport(request);
                createdReports.add(report);
            } catch (Exception e) {
                errors.add("Failed to create report for: " + request.getTitle() + " - " + e.getMessage());
                log.error("Failed to create bulk error report", e);
            }
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("created", createdReports.size());
        result.put("failed", errors.size());
        result.put("reports", createdReports);
        result.put("errors", errors);
        
        return result;
    }
    
    private ErrorReportDto convertToDto(ErrorReport report) {
        return ErrorReportDto.builder()
                .id(report.getId())
                .title(report.getTitle())
                .description(report.getDescription())
                .errorType(report.getErrorType())
                .severity(report.getSeverity().name())
                .status(report.getStatus().name())
                .userAgent(report.getUserAgent())
                .url(report.getUrl())
                .stackTrace(report.getStackTrace())
                .userId(report.getUserId())
                .createdAt(report.getCreatedAt())
                .updatedAt(report.getUpdatedAt())
                .build();
    }
}