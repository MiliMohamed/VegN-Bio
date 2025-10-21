package com.vegnbio.api.modules.errorreporting.dto;

import java.time.LocalDateTime;

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
    
    public ErrorReportDto() {}
    
    public ErrorReportDto(Long id, String title, String description, String errorType, String severity,
                         String status, String userAgent, String url, String stackTrace, String userId,
                         LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.errorType = errorType;
        this.severity = severity;
        this.status = status;
        this.userAgent = userAgent;
        this.url = url;
        this.stackTrace = stackTrace;
        this.userId = userId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public static ErrorReportDtoBuilder builder() {
        return new ErrorReportDtoBuilder();
    }
    
    public static class ErrorReportDtoBuilder {
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
        
        public ErrorReportDtoBuilder id(Long id) { this.id = id; return this; }
        public ErrorReportDtoBuilder title(String title) { this.title = title; return this; }
        public ErrorReportDtoBuilder description(String description) { this.description = description; return this; }
        public ErrorReportDtoBuilder errorType(String errorType) { this.errorType = errorType; return this; }
        public ErrorReportDtoBuilder severity(String severity) { this.severity = severity; return this; }
        public ErrorReportDtoBuilder status(String status) { this.status = status; return this; }
        public ErrorReportDtoBuilder userAgent(String userAgent) { this.userAgent = userAgent; return this; }
        public ErrorReportDtoBuilder url(String url) { this.url = url; return this; }
        public ErrorReportDtoBuilder stackTrace(String stackTrace) { this.stackTrace = stackTrace; return this; }
        public ErrorReportDtoBuilder userId(String userId) { this.userId = userId; return this; }
        public ErrorReportDtoBuilder createdAt(LocalDateTime createdAt) { this.createdAt = createdAt; return this; }
        public ErrorReportDtoBuilder updatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; return this; }
        
        public ErrorReportDto build() {
            return new ErrorReportDto(id, title, description, errorType, severity, status, userAgent, url, stackTrace, userId, createdAt, updatedAt);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getErrorType() { return errorType; }
    public void setErrorType(String errorType) { this.errorType = errorType; }
    
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    
    public String getStackTrace() { return stackTrace; }
    public void setStackTrace(String stackTrace) { this.stackTrace = stackTrace; }
    
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}