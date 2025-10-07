package com.vegnbio.api.modules.feedback.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateReportRequest(
        @NotNull Long restaurantId,
        @NotBlank String reporterName,
        @Email String reporterEmail,
        @NotBlank String reportType,
        @NotBlank String description
) {}

