package com.vegnbio.api.modules.chatbot.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageDto {
    
    private String id;
    private String text;
    private LocalDateTime createdAt;
    private String userId;
    private String type;
    private Map<String, Object> metadata;
}
