package com.vegnbio.api.modules.errorreporting.controller;

import com.vegnbio.api.modules.errorreporting.dto.ErrorReportDto;
import com.vegnbio.api.modules.errorreporting.dto.CreateErrorReportRequest;
import com.vegnbio.api.modules.errorreporting.service.ErrorReportingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/error-reports")
@RequiredArgsConstructor
public class ErrorReportingController {
    
    private final ErrorReportingService errorReportingService;
    
    @PostMapping
    public ResponseEntity<ErrorReportDto> createErrorReport(@Valid @RequestBody CreateErrorReportRequest request) {
        ErrorReportDto report = errorReportingService.createErrorReport(request);
        return ResponseEntity.ok(report);
    }
    
    @GetMapping
    public ResponseEntity<List<ErrorReportDto>> getAllErrorReports(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String severity) {
        List<ErrorReportDto> reports = errorReportingService.getAllErrorReports(status, severity);
        return ResponseEntity.ok(reports);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ErrorReportDto> getErrorReport(@PathVariable Long id) {
        ErrorReportDto report = errorReportingService.getErrorReportById(id);
        return ResponseEntity.ok(report);
    }
    
    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getErrorStatistics() {
        Map<String, Object> statistics = errorReportingService.getErrorStatistics();
        return ResponseEntity.ok(statistics);
    }
    
    @GetMapping("/recent")
    public ResponseEntity<List<ErrorReportDto>> getRecentErrors(@RequestParam(defaultValue = "24") int hours) {
        List<ErrorReportDto> reports = errorReportingService.getRecentErrors(hours);
        return ResponseEntity.ok(reports);
    }
    
    @PatchMapping("/{id}/status")
    public ResponseEntity<ErrorReportDto> updateErrorStatus(
            @PathVariable Long id, 
            @RequestParam String status) {
        ErrorReportDto report = errorReportingService.updateErrorStatus(id, status);
        return ResponseEntity.ok(report);
    }
    
    @PostMapping("/bulk")
    public ResponseEntity<Map<String, Object>> createBulkErrorReports(@Valid @RequestBody List<CreateErrorReportRequest> requests) {
        Map<String, Object> result = errorReportingService.createBulkErrorReports(requests);
        return ResponseEntity.ok(result);
    }
}