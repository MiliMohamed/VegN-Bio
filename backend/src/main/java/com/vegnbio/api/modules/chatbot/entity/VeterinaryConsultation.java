package com.vegnbio.api.modules.chatbot.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "veterinary_consultations")
public class VeterinaryConsultation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String animalBreed;
    
    @ElementCollection
    @CollectionTable(name = "consultation_symptoms", joinColumns = @JoinColumn(name = "consultation_id"))
    @Column(name = "symptom")
    private List<String> symptoms;
    
    @Column(columnDefinition = "TEXT")
    private String diagnosis;
    
    @Column(columnDefinition = "TEXT")
    private String recommendation;
    
    @Column(nullable = false)
    private Double confidence;
    
    @Column(name = "user_id")
    private String userId;
    
    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    // Constructors
    public VeterinaryConsultation() {}
    
    public VeterinaryConsultation(Long id, String animalBreed, List<String> symptoms, String diagnosis,
                                 String recommendation, Double confidence, String userId, LocalDateTime createdAt) {
        this.id = id;
        this.animalBreed = animalBreed;
        this.symptoms = symptoms;
        this.diagnosis = diagnosis;
        this.recommendation = recommendation;
        this.confidence = confidence;
        this.userId = userId;
        this.createdAt = createdAt;
    }
    
    // Builder pattern
    public static VeterinaryConsultationBuilder builder() {
        return new VeterinaryConsultationBuilder();
    }
    
    public static class VeterinaryConsultationBuilder {
        private Long id;
        private String animalBreed;
        private List<String> symptoms;
        private String diagnosis;
        private String recommendation;
        private Double confidence;
        private String userId;
        private LocalDateTime createdAt;
        
        public VeterinaryConsultationBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public VeterinaryConsultationBuilder animalBreed(String animalBreed) {
            this.animalBreed = animalBreed;
            return this;
        }
        
        public VeterinaryConsultationBuilder symptoms(List<String> symptoms) {
            this.symptoms = symptoms;
            return this;
        }
        
        public VeterinaryConsultationBuilder diagnosis(String diagnosis) {
            this.diagnosis = diagnosis;
            return this;
        }
        
        public VeterinaryConsultationBuilder recommendation(String recommendation) {
            this.recommendation = recommendation;
            return this;
        }
        
        public VeterinaryConsultationBuilder confidence(Double confidence) {
            this.confidence = confidence;
            return this;
        }
        
        public VeterinaryConsultationBuilder userId(String userId) {
            this.userId = userId;
            return this;
        }
        
        public VeterinaryConsultationBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public VeterinaryConsultation build() {
            return new VeterinaryConsultation(id, animalBreed, symptoms, diagnosis, recommendation, confidence, userId, createdAt);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
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
    
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
