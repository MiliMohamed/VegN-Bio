package com.vegnbio.restaurant.controller;

import com.vegnbio.restaurant.dto.ErrorReportDto;
import com.vegnbio.restaurant.service.ErrorReportingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ErrorReportController {

    private final ErrorReportingService errorReportingService;

    /**
     * Soumet un nouveau rapport d'erreur
     */
    @PostMapping
    public ResponseEntity<ErrorReportDto> submitErrorReport(@RequestBody ErrorReportDto errorReport) {
        return ResponseEntity.ok(errorReportingService.submitErrorReport(errorReport));
    }

    /**
     * Récupère tous les rapports d'erreurs (ADMIN)
     */
    @GetMapping
    public ResponseEntity<List<ErrorReportDto>> getAllErrorReports() {
        return ResponseEntity.ok(errorReportingService.getAllErrorReports());
    }

    /**
     * Récupère les rapports par sévérité
     */
    @GetMapping("/severity/{severity}")
    public ResponseEntity<List<ErrorReportDto>> getReportsBySeverity(@PathVariable String severity) {
        return ResponseEntity.ok(errorReportingService.getReportsBySeverity(severity));
    }

    /**
     * Récupère les statistiques des rapports
     */
    @GetMapping("/stats")
    public ResponseEntity<Object> getReportStats() {
        return ResponseEntity.ok(errorReportingService.getReportStats());
    }

    /**
     * Marque un rapport comme résolu (ADMIN)
     */
    @PutMapping("/{id}/resolve")
    public ResponseEntity<ErrorReportDto> resolveReport(@PathVariable Long id) {
        return ResponseEntity.ok(errorReportingService.resolveReport(id));
    }
}
