package com.vegnbio.api.modules.chatbot.dto;

import java.util.List;

public class ConsultationRequest {
    
    private String animalBreed;
    private List<String> symptoms;
    private String diagnosis;
    private String recommendation;
    private String userId;
    private String timestamp;
    
    public ConsultationRequest() {}
    
    public ConsultationRequest(String animalBreed, List<String> symptoms, String diagnosis,
                              String recommendation, String userId, String timestamp) {
        this.animalBreed = animalBreed;
        this.symptoms = symptoms;
        this.diagnosis = diagnosis;
        this.recommendation = recommendation;
        this.userId = userId;
        this.timestamp = timestamp;
    }
    
    public static ConsultationRequestBuilder builder() {
        return new ConsultationRequestBuilder();
    }
    
    public static class ConsultationRequestBuilder {
        private String animalBreed;
        private List<String> symptoms;
        private String diagnosis;
        private String recommendation;
        private String userId;
        private String timestamp;
        
        public ConsultationRequestBuilder animalBreed(String animalBreed) {
            this.animalBreed = animalBreed;
            return this;
        }
        
        public ConsultationRequestBuilder symptoms(List<String> symptoms) {
            this.symptoms = symptoms;
            return this;
        }
        
        public ConsultationRequestBuilder diagnosis(String diagnosis) {
            this.diagnosis = diagnosis;
            return this;
        }
        
        public ConsultationRequestBuilder recommendation(String recommendation) {
            this.recommendation = recommendation;
            return this;
        }
        
        public ConsultationRequestBuilder userId(String userId) {
            this.userId = userId;
            return this;
        }
        
        public ConsultationRequestBuilder timestamp(String timestamp) {
            this.timestamp = timestamp;
            return this;
        }
        
        public ConsultationRequest build() {
            return new ConsultationRequest(animalBreed, symptoms, diagnosis, recommendation, userId, timestamp);
        }
    }
    
    // Getters and Setters
    public String getAnimalBreed() { return animalBreed; }
    public void setAnimalBreed(String animalBreed) { this.animalBreed = animalBreed; }
    
    public List<String> getSymptoms() { return symptoms; }
    public void setSymptoms(List<String> symptoms) { this.symptoms = symptoms; }
    
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    
    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
    
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
}
