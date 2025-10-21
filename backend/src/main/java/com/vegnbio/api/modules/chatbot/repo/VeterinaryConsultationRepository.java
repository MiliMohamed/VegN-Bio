package com.vegnbio.api.modules.chatbot.repo;

import com.vegnbio.api.modules.chatbot.entity.VeterinaryConsultation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface VeterinaryConsultationRepository extends JpaRepository<VeterinaryConsultation, Long> {
    
    List<VeterinaryConsultation> findByUserIdOrderByCreatedAtDesc(String userId);
    
    List<VeterinaryConsultation> findByAnimalBreedOrderByCreatedAtDesc(String animalBreed);
    
    @Query("SELECT DISTINCT v.animalBreed FROM VeterinaryConsultation v ORDER BY v.animalBreed")
    List<String> findDistinctAnimalBreeds();
    
    @Query("SELECT DISTINCT s FROM VeterinaryConsultation v JOIN v.symptoms s ORDER BY s")
    List<String> findDistinctSymptoms();
    
    @Query("SELECT DISTINCT s FROM VeterinaryConsultation v JOIN v.symptoms s WHERE v.animalBreed = :breed")
    List<String> findDistinctSymptomsByBreed(@Param("breed") String breed);
    
    @Query("SELECT v FROM VeterinaryConsultation v WHERE v.createdAt BETWEEN :startDate AND :endDate ORDER BY v.createdAt DESC")
    List<VeterinaryConsultation> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, 
                                                        @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(v) FROM VeterinaryConsultation v WHERE v.animalBreed = :breed")
    Long countByAnimalBreed(@Param("breed") String breed);
}
