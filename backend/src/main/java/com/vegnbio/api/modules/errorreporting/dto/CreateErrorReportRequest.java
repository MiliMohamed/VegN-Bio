package com.vegnbio.api.modules.errorreporting.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateErrorReportRequest(
    @NotBlank(message = "Title is required")
    String title,
    
    @NotBlank(message = "Description is required")
    String description,
    
    @NotBlank(message = "Error type is required")
    String errorType,
    
    @NotNull(message = "Severity is required")
    String severity,
    
    String userAgent,
    String url,
    String stackTrace,
    String userId
) {}