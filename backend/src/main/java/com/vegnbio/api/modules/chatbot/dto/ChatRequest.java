package com.vegnbio.api.modules.chatbot.dto;

public class ChatRequest {
    
    private String message;
    private String userId;
    private String timestamp;
    
    public ChatRequest() {}
    
    public ChatRequest(String message, String userId, String timestamp) {
        this.message = message;
        this.userId = userId;
        this.timestamp = timestamp;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getUserId() {
        return userId;
    }
    
    public void setUserId(String userId) {
        this.userId = userId;
    }
    
    public String getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
}
