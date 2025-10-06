package com.vegnbio.api.modules.feedback.service;

import com.vegnbio.api.modules.feedback.dto.CreateReportRequest;
import com.vegnbio.api.modules.feedback.dto.ReportDto;
import com.vegnbio.api.modules.feedback.dto.UpdateReportStatusRequest;
import com.vegnbio.api.modules.feedback.entity.Report;
import com.vegnbio.api.modules.feedback.entity.ReportStatus;
import com.vegnbio.api.modules.feedback.repo.ReportRepository;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportRepository reportRepository;
    private final RestaurantRepository restaurantRepository;

    @Transactional
    public ReportDto createReport(CreateReportRequest request) {
        var restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        var report = Report.builder()
                .restaurant(restaurant)
                .reporterName(request.reporterName())
                .reporterEmail(request.reporterEmail())
                .reportType(request.reportType())
                .description(request.description())
                .status(ReportStatus.OPEN)
                .build();
        
        reportRepository.save(report);
        return toDto(report);
    }

    @Transactional(readOnly = true)
    public List<ReportDto> getActiveReports() {
        return reportRepository.findActiveReports()
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ReportDto> getReportsByRestaurant(Long restaurantId) {
        return reportRepository.findByRestaurantId(restaurantId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ReportDto> getActiveReportsByRestaurant(Long restaurantId) {
        return reportRepository.findActiveReportsByRestaurant(restaurantId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ReportDto> getReportsByStatus(ReportStatus status) {
        return reportRepository.findByStatus(status)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ReportDto getReportById(Long reportId) {
        var report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        return toDto(report);
    }

    @Transactional
    public ReportDto updateReportStatus(Long reportId, UpdateReportStatusRequest request) {
        var report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));
        
        report.setStatus(request.status());
        
        if (request.status() == ReportStatus.RESOLVED || request.status() == ReportStatus.CLOSED) {
            report.setResolvedAt(LocalDateTime.now());
        }
        
        reportRepository.save(report);
        return toDto(report);
    }

    private ReportDto toDto(Report report) {
        return new ReportDto(
                report.getId(),
                report.getRestaurant().getId(),
                report.getReporterName(),
                report.getReporterEmail(),
                report.getReportType(),
                report.getDescription(),
                report.getStatus(),
                report.getCreatedAt(),
                report.getResolvedAt()
        );
    }
}
