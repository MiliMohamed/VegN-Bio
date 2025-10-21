package com.vegnbio.api.modules.errorreporting.dto;

import lombok.Builder;
import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Data
@Builder
public class ErrorReportDto {
    private Long id;
    private String title;
    private String description;
    private String errorType;
    private String severity;
    private String status;
    private String userAgent;
    private String url;
    private String stackTrace;
    private String userId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

@Data
@Builder
public class CreateErrorReportRequest {
    @NotBlank(message = "Title is required")
    private String title;
    
    @NotBlank(message = "Description is required")
    private String description;
    
    @NotBlank(message = "Error type is required")
    private String errorType;
    
    @NotNull(message = "Severity is required")
    private String severity;
    
    private String userAgent;
    private String url;
    private String stackTrace;
    private String userId;
}