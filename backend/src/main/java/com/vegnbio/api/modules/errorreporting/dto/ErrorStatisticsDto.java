package com.vegnbio.api.modules.errorreporting.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ErrorStatisticsDto {
    
    private Long totalErrors;
    private Long errorsByType;
    private Long errorsByUser;
    private Long errorsByDevice;
    private Map<String, Long> errorTypeCount;
    private Map<String, Long> userErrorCount;
    private Map<String, Long> deviceErrorCount;
}
