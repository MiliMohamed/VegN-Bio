package com.vegnbio.api.modules.feedback.dto;

import com.vegnbio.api.modules.feedback.entity.ReportStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateReportStatusRequest(
        @NotNull ReportStatus status
) {}

