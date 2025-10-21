package com.vegnbio.api.modules.errorreporting.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "error_reports")
public class ErrorReport {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String title;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "error_type", nullable = false)
    private String errorType;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ErrorSeverity severity;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ErrorStatus status;
    
    @Column(name = "user_agent")
    private String userAgent;
    
    @Column(name = "url")
    private String url;
    
    @Column(name = "stack_trace", columnDefinition = "TEXT")
    private String stackTrace;
    
    @Column(name = "user_id")
    private String userId;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // Constructors
    public ErrorReport() {}
    
    public ErrorReport(Long id, String title, String description, String errorType, ErrorSeverity severity,
                      ErrorStatus status, String userAgent, String url, String stackTrace, String userId,
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
    
    // Builder pattern
    public static ErrorReportBuilder builder() {
        return new ErrorReportBuilder();
    }
    
    public static class ErrorReportBuilder {
        private Long id;
        private String title;
        private String description;
        private String errorType;
        private ErrorSeverity severity;
        private ErrorStatus status;
        private String userAgent;
        private String url;
        private String stackTrace;
        private String userId;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        public ErrorReportBuilder id(Long id) { this.id = id; return this; }
        public ErrorReportBuilder title(String title) { this.title = title; return this; }
        public ErrorReportBuilder description(String description) { this.description = description; return this; }
        public ErrorReportBuilder errorType(String errorType) { this.errorType = errorType; return this; }
        public ErrorReportBuilder severity(ErrorSeverity severity) { this.severity = severity; return this; }
        public ErrorReportBuilder status(ErrorStatus status) { this.status = status; return this; }
        public ErrorReportBuilder userAgent(String userAgent) { this.userAgent = userAgent; return this; }
        public ErrorReportBuilder url(String url) { this.url = url; return this; }
        public ErrorReportBuilder stackTrace(String stackTrace) { this.stackTrace = stackTrace; return this; }
        public ErrorReportBuilder userId(String userId) { this.userId = userId; return this; }
        public ErrorReportBuilder createdAt(LocalDateTime createdAt) { this.createdAt = createdAt; return this; }
        public ErrorReportBuilder updatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; return this; }
        
        public ErrorReport build() {
            return new ErrorReport(id, title, description, errorType, severity, status, userAgent, url, stackTrace, userId, createdAt, updatedAt);
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
    
    public ErrorSeverity getSeverity() { return severity; }
    public void setSeverity(ErrorSeverity severity) { this.severity = severity; }
    
    public ErrorStatus getStatus() { return status; }
    public void setStatus(ErrorStatus status) { this.status = status; }
    
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
