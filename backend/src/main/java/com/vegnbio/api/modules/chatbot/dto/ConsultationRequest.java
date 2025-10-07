package com.vegnbio.api.modules.chatbot.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ConsultationRequest {
    
    private String animalBreed;
    private List<String> symptoms;
    private String diagnosis;
    private String recommendation;
    private String userId;
    private String timestamp;
}
