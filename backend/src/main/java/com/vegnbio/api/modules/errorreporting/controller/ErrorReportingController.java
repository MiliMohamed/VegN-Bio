package com.vegnbio.api.modules.errorreporting.controller;

import com.vegnbio.api.modules.errorreporting.dto.*;
import com.vegnbio.api.modules.errorreporting.service.ErrorReportingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/errors")
@RequiredArgsConstructor
public class ErrorReportingController {
    
    private final ErrorReportingService errorReportingService;
    
    @PostMapping("/report")
    public ResponseEntity<Void> reportError(@Valid @RequestBody ErrorReportRequest request) {
        errorReportingService.reportError(request);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ErrorReportDto>> getErrorReportsByUser(@PathVariable String userId) {
        List<ErrorReportDto> reports = errorReportingService.getErrorReports(userId);
        return ResponseEntity.ok(reports);
    }
    
    @GetMapping("/type/{errorType}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ErrorReportDto>> getErrorReportsByType(@PathVariable String errorType) {
        List<ErrorReportDto> reports = errorReportingService.getErrorReportsByType(errorType);
        return ResponseEntity.ok(reports);
    }
    
    @GetMapping("/statistics")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ErrorStatisticsDto> getErrorStatistics(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        
        LocalDateTime start = startDate != null ? startDate : LocalDateTime.now().minusDays(30);
        LocalDateTime end = endDate != null ? endDate : LocalDateTime.now();
        
        ErrorStatisticsDto statistics = errorReportingService.getErrorStatistics(start, end);
        return ResponseEntity.ok(statistics);
    }
    
    @DeleteMapping("/cleanup")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> cleanupOldReports(@RequestParam(defaultValue = "30") int daysToKeep) {
        errorReportingService.cleanupOldReports(daysToKeep);
        return ResponseEntity.ok().build();
    }
}
