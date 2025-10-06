package com.vegnbio.api.modules.feedback.dto;

import com.vegnbio.api.modules.feedback.entity.ReportStatus;

import java.time.LocalDateTime;

public record ReportDto(
        Long id,
        Long restaurantId,
        String reporterName,
        String reporterEmail,
        String reportType,
        String description,
        ReportStatus status,
        LocalDateTime createdAt,
        LocalDateTime resolvedAt
) {}
