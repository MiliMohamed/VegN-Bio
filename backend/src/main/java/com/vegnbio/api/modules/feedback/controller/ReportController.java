package com.vegnbio.api.modules.feedback.controller;

import com.vegnbio.api.modules.feedback.dto.CreateReportRequest;
import com.vegnbio.api.modules.feedback.dto.ReportDto;
import com.vegnbio.api.modules.feedback.dto.UpdateReportStatusRequest;
import com.vegnbio.api.modules.feedback.entity.ReportStatus;
import com.vegnbio.api.modules.feedback.service.ReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping
    public ResponseEntity<ReportDto> createReport(@Valid @RequestBody CreateReportRequest request) {
        ReportDto report = reportService.createReport(request);
        return ResponseEntity.ok(report);
    }

    @GetMapping("/active")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ReportDto>> getActiveReports() {
        List<ReportDto> reports = reportService.getActiveReports();
        return ResponseEntity.ok(reports);
    }

    @GetMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<ReportDto>> getReportsByRestaurant(@PathVariable Long restaurantId) {
        List<ReportDto> reports = reportService.getReportsByRestaurant(restaurantId);
        return ResponseEntity.ok(reports);
    }

    @GetMapping("/restaurant/{restaurantId}/active")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<ReportDto>> getActiveReportsByRestaurant(@PathVariable Long restaurantId) {
        List<ReportDto> reports = reportService.getActiveReportsByRestaurant(restaurantId);
        return ResponseEntity.ok(reports);
    }

    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ReportDto>> getReportsByStatus(@PathVariable ReportStatus status) {
        List<ReportDto> reports = reportService.getReportsByStatus(status);
        return ResponseEntity.ok(reports);
    }

    @GetMapping("/{reportId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ReportDto> getReport(@PathVariable Long reportId) {
        ReportDto report = reportService.getReportById(reportId);
        return ResponseEntity.ok(report);
    }

    @PatchMapping("/{reportId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ReportDto> updateReportStatus(
            @PathVariable Long reportId,
            @Valid @RequestBody UpdateReportStatusRequest request
    ) {
        ReportDto report = reportService.updateReportStatus(reportId, request);
        return ResponseEntity.ok(report);
    }
}
