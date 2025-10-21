package com.vegnbio.api.modules.chatbot.dto;

import java.time.LocalDateTime;
import java.util.List;

public class VeterinaryDiagnosisDto {
    
    private String id;
    private String animalBreed;
    private List<String> symptoms;
    private String diagnosis;
    private String recommendation;
    private Double confidence;
    private LocalDateTime createdAt;
    
    public VeterinaryDiagnosisDto() {}
    
    public VeterinaryDiagnosisDto(String id, String animalBreed, List<String> symptoms, String diagnosis,
                                 String recommendation, Double confidence, LocalDateTime createdAt) {
        this.id = id;
        this.animalBreed = animalBreed;
        this.symptoms = symptoms;
        this.diagnosis = diagnosis;
        this.recommendation = recommendation;
        this.confidence = confidence;
        this.createdAt = createdAt;
    }
    
    public static VeterinaryDiagnosisDtoBuilder builder() {
        return new VeterinaryDiagnosisDtoBuilder();
    }
    
    public static class VeterinaryDiagnosisDtoBuilder {
        private String id;
        private String animalBreed;
        private List<String> symptoms;
        private String diagnosis;
        private String recommendation;
        private Double confidence;
        private LocalDateTime createdAt;
        
        public VeterinaryDiagnosisDtoBuilder id(String id) {
            this.id = id;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder animalBreed(String animalBreed) {
            this.animalBreed = animalBreed;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder symptoms(List<String> symptoms) {
            this.symptoms = symptoms;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder diagnosis(String diagnosis) {
            this.diagnosis = diagnosis;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder recommendation(String recommendation) {
            this.recommendation = recommendation;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder confidence(Double confidence) {
            this.confidence = confidence;
            return this;
        }
        
        public VeterinaryDiagnosisDtoBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public VeterinaryDiagnosisDto build() {
            return new VeterinaryDiagnosisDto(id, animalBreed, symptoms, diagnosis, recommendation, confidence, createdAt);
        }
    }
    
    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getAnimalBreed() { return animalBreed; }
    public void setAnimalBreed(String animalBreed) { this.animalBreed = animalBreed; }
    
    public List<String> getSymptoms() { return symptoms; }
    public void setSymptoms(List<String> symptoms) { this.symptoms = symptoms; }
    
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    
    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
    
    public Double getConfidence() { return confidence; }
    public void setConfidence(Double confidence) { this.confidence = confidence; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
