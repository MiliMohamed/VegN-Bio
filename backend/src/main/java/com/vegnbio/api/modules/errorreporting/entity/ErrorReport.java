package com.vegnbio.api.modules.errorreporting.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

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
    
    @Column(name = "error_type", nullable = false)
    private String errorType;
    
    @Column(name = "error_message", nullable = false, columnDefinition = "TEXT")
    private String errorMessage;
    
    @Column(name = "stack_trace", columnDefinition = "TEXT")
    private String stackTrace;
    
    @Column(name = "user_id")
    private String userId;
    
    @Column(name = "device_info")
    private String deviceInfo;
    
    @Column(name = "app_version")
    private String appVersion;
    
    @Column(name = "timestamp", nullable = false)
    private LocalDateTime timestamp;
    
    @ElementCollection
    @CollectionTable(name = "error_report_additional_data", joinColumns = @JoinColumn(name = "error_report_id"))
    @MapKeyColumn(name = "data_key")
    @Column(name = "data_value")
    private Map<String, String> additionalData;
    
    @PrePersist
    protected void onCreate() {
        timestamp = LocalDateTime.now();
    }
}
