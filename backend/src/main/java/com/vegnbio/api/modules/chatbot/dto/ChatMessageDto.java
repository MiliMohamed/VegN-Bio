package com.vegnbio.api.modules.chatbot.dto;

import java.time.LocalDateTime;
import java.util.Map;

public class ChatMessageDto {
    
    private String id;
    private String text;
    private LocalDateTime createdAt;
    private String userId;
    private String type;
    private Map<String, Object> metadata;
    
    public ChatMessageDto() {}
    
    public ChatMessageDto(String id, String text, LocalDateTime createdAt, String userId, String type, Map<String, Object> metadata) {
        this.id = id;
        this.text = text;
        this.createdAt = createdAt;
        this.userId = userId;
        this.type = type;
        this.metadata = metadata;
    }
    
    public static ChatMessageDtoBuilder builder() {
        return new ChatMessageDtoBuilder();
    }
    
    public static class ChatMessageDtoBuilder {
        private String id;
        private String text;
        private LocalDateTime createdAt;
        private String userId;
        private String type;
        private Map<String, Object> metadata;
        
        public ChatMessageDtoBuilder id(String id) {
            this.id = id;
            return this;
        }
        
        public ChatMessageDtoBuilder text(String text) {
            this.text = text;
            return this;
        }
        
        public ChatMessageDtoBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public ChatMessageDtoBuilder userId(String userId) {
            this.userId = userId;
            return this;
        }
        
        public ChatMessageDtoBuilder type(String type) {
            this.type = type;
            return this;
        }
        
        public ChatMessageDtoBuilder metadata(Map<String, Object> metadata) {
            this.metadata = metadata;
            return this;
        }
        
        public ChatMessageDto build() {
            return new ChatMessageDto(id, text, createdAt, userId, type, metadata);
        }
    }
    
    public String getId() {
        return id;
    }
    
    public void setId(String id) {
        this.id = id;
    }
    
    public String getText() {
        return text;
    }
    
    public void setText(String text) {
        this.text = text;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public Map<String, Object> getMetadata() {
        return metadata;
    }
    
    public void setMetadata(Map<String, Object> metadata) {
        this.metadata = metadata;
    }
}
