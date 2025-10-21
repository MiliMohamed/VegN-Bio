package com.vegnbio.api.modules.chatbot.dto;

import java.util.List;

public class DiagnosisRequest {
    
    private String animalBreed;
    private List<String> symptoms;
    private String userId;
    private String timestamp;
    
    public DiagnosisRequest() {}
    
    public DiagnosisRequest(String animalBreed, List<String> symptoms, String userId, String timestamp) {
        this.animalBreed = animalBreed;
        this.symptoms = symptoms;
        this.userId = userId;
        this.timestamp = timestamp;
    }
    
    public String getAnimalBreed() {
        return animalBreed;
    }
    
    public void setAnimalBreed(String animalBreed) {
        this.animalBreed = animalBreed;
    }
    
    public List<String> getSymptoms() {
        return symptoms;
    }
    
    public void setSymptoms(List<String> symptoms) {
        this.symptoms = symptoms;
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
