package com.vegnbio.api.modules.errorreporting.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

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
    
    public CreateErrorReportRequest() {}
    
    public CreateErrorReportRequest(String title, String description, String errorType, String severity,
                                   String userAgent, String url, String stackTrace, String userId) {
        this.title = title;
        this.description = description;
        this.errorType = errorType;
        this.severity = severity;
        this.userAgent = userAgent;
        this.url = url;
        this.stackTrace = stackTrace;
        this.userId = userId;
    }
    
    public static CreateErrorReportRequestBuilder builder() {
        return new CreateErrorReportRequestBuilder();
    }
    
    public static class CreateErrorReportRequestBuilder {
        private String title;
        private String description;
        private String errorType;
        private String severity;
        private String userAgent;
        private String url;
        private String stackTrace;
        private String userId;
        
        public CreateErrorReportRequestBuilder title(String title) { this.title = title; return this; }
        public CreateErrorReportRequestBuilder description(String description) { this.description = description; return this; }
        public CreateErrorReportRequestBuilder errorType(String errorType) { this.errorType = errorType; return this; }
        public CreateErrorReportRequestBuilder severity(String severity) { this.severity = severity; return this; }
        public CreateErrorReportRequestBuilder userAgent(String userAgent) { this.userAgent = userAgent; return this; }
        public CreateErrorReportRequestBuilder url(String url) { this.url = url; return this; }
        public CreateErrorReportRequestBuilder stackTrace(String stackTrace) { this.stackTrace = stackTrace; return this; }
        public CreateErrorReportRequestBuilder userId(String userId) { this.userId = userId; return this; }
        
        public CreateErrorReportRequest build() {
            return new CreateErrorReportRequest(title, description, errorType, severity, userAgent, url, stackTrace, userId);
        }
    }
    
    // Getters and Setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getErrorType() { return errorType; }
    public void setErrorType(String errorType) { this.errorType = errorType; }
    
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    
    public String getStackTrace() { return stackTrace; }
    public void setStackTrace(String stackTrace) { this.stackTrace = stackTrace; }
    
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
}
