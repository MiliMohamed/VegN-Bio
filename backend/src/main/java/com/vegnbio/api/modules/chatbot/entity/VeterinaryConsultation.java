package com.vegnbio.api.modules.chatbot.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "veterinary_consultations")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
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
}
