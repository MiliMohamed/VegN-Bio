package com.vegnbio.api.modules.errorreporting.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "error_reports")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
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
}

enum ErrorSeverity {
    LOW, MEDIUM, HIGH, CRITICAL
}

enum ErrorStatus {
    OPEN, IN_PROGRESS, RESOLVED, CLOSED
}