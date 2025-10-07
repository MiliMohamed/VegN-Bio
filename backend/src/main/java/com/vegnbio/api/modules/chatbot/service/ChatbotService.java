package com.vegnbio.api.modules.chatbot.service;

import com.vegnbio.api.modules.chatbot.dto.*;
import com.vegnbio.api.modules.chatbot.entity.VeterinaryConsultation;
import com.vegnbio.api.modules.chatbot.repo.VeterinaryConsultationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatbotService {
    
    private final VeterinaryConsultationRepository consultationRepository;
    
    // Base de données de connaissances vétérinaires
    private final Map<String, Map<String, String>> veterinaryKnowledge = initializeVeterinaryKnowledge();
    
    public ChatMessageDto sendMessage(ChatRequest request) {
        log.info("Processing chat message: {}", request.getMessage());
        
        String response = generateResponse(request.getMessage());
        
        return ChatMessageDto.builder()
                .id(UUID.randomUUID().toString())
                .text(response)
                .createdAt(LocalDateTime.now())
                .userId("bot")
                .type("text")
                .build();
    }
    
    public VeterinaryDiagnosisDto getVeterinaryDiagnosis(DiagnosisRequest request) {
        log.info("Processing diagnosis request for breed: {} with symptoms: {}", 
                request.getAnimalBreed(), request.getSymptoms());
        
        // Rechercher des consultations similaires dans la base de données
        List<VeterinaryConsultation> similarConsultations = findSimilarConsultations(
                request.getAnimalBreed(), request.getSymptoms());
        
        String diagnosis = generateDiagnosis(request.getAnimalBreed(), request.getSymptoms(), similarConsultations);
        String recommendation = generateRecommendation(request.getAnimalBreed(), request.getSymptoms(), diagnosis);
        Double confidence = calculateConfidence(request.getAnimalBreed(), request.getSymptoms(), similarConsultations);
        
        return VeterinaryDiagnosisDto.builder()
                .id(UUID.randomUUID().toString())
                .animalBreed(request.getAnimalBreed())
                .symptoms(request.getSymptoms())
                .diagnosis(diagnosis)
                .recommendation(recommendation)
                .confidence(confidence)
                .createdAt(LocalDateTime.now())
                .build();
    }
    
    public List<String> getRecommendations(DiagnosisRequest request) {
        VeterinaryDiagnosisDto diagnosis = getVeterinaryDiagnosis(request);
        return Arrays.asList(diagnosis.getRecommendation().split("\n"));
    }
    
    public void saveConsultation(ConsultationRequest request) {
        log.info("Saving consultation for breed: {} with diagnosis: {}", 
                request.getAnimalBreed(), request.getDiagnosis());
        
        VeterinaryConsultation consultation = VeterinaryConsultation.builder()
                .animalBreed(request.getAnimalBreed())
                .symptoms(request.getSymptoms())
                .diagnosis(request.getDiagnosis())
                .recommendation(request.getRecommendation())
                .confidence(0.8) // Confiance par défaut
                .userId(request.getUserId())
                .createdAt(LocalDateTime.now())
                .build();
        
        consultationRepository.save(consultation);
    }
    
    public List<VeterinaryDiagnosisDto> getConsultationHistory(String userId) {
        List<VeterinaryConsultation> consultations = consultationRepository.findByUserIdOrderByCreatedAtDesc(userId);
        
        return consultations.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public List<String> getSupportedBreeds() {
        List<String> breeds = consultationRepository.findDistinctAnimalBreeds();
        
        // Ajouter les races communes si la base de données est vide
        if (breeds.isEmpty()) {
            breeds = Arrays.asList(
                    "Chien", "Chat", "Lapin", "Hamster", "Cochon d'Inde", 
                    "Oiseau", "Poisson", "Tortue", "Lézard", "Serpent"
            );
        }
        
        return breeds;
    }
    
    public List<String> getCommonSymptoms(String breed) {
        List<String> symptoms = consultationRepository.findDistinctSymptomsByBreed(breed);
        
        // Ajouter des symptômes communs si la base de données est vide
        if (symptoms.isEmpty()) {
            symptoms = getDefaultSymptomsForBreed(breed);
        }
        
        return symptoms;
    }
    
    private List<VeterinaryConsultation> findSimilarConsultations(String breed, List<String> symptoms) {
        List<VeterinaryConsultation> consultations = consultationRepository.findByAnimalBreedOrderByCreatedAtDesc(breed);
        
        // Filtrer les consultations avec des symptômes similaires
        return consultations.stream()
                .filter(consultation -> {
                    long commonSymptoms = consultation.getSymptoms().stream()
                            .filter(symptoms::contains)
                            .count();
                    return commonSymptoms > 0;
                })
                .sorted((c1, c2) -> {
                    long symptoms1 = c1.getSymptoms().stream().filter(symptoms::contains).count();
                    long symptoms2 = c2.getSymptoms().stream().filter(symptoms::contains).count();
                    return Long.compare(symptoms2, symptoms1);
                })
                .limit(5)
                .collect(Collectors.toList());
    }
    
    private String generateDiagnosis(String breed, List<String> symptoms, List<VeterinaryConsultation> similarConsultations) {
        if (!similarConsultations.isEmpty()) {
            // Utiliser les diagnostics des consultations similaires
            Map<String, Long> diagnosisCount = similarConsultations.stream()
                    .collect(Collectors.groupingBy(
                            VeterinaryConsultation::getDiagnosis,
                            Collectors.counting()
                    ));
            
            return diagnosisCount.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("Diagnostic basé sur les symptômes observés");
        }
        
        // Utiliser la base de connaissances
        return veterinaryKnowledge.getOrDefault(breed.toLowerCase(), new HashMap<>())
                .getOrDefault(symptoms.get(0).toLowerCase(), "Consultez un vétérinaire pour un diagnostic précis");
    }
    
    private String generateRecommendation(String breed, List<String> symptoms, String diagnosis) {
        StringBuilder recommendations = new StringBuilder();
        
        recommendations.append("Recommandations pour ").append(breed).append(":\n");
        recommendations.append("1. Surveillez l'évolution des symptômes\n");
        recommendations.append("2. Assurez-vous que l'animal reste hydraté\n");
        recommendations.append("3. Consultez un vétérinaire si les symptômes persistent\n");
        
        if (symptoms.contains("fièvre")) {
            recommendations.append("4. Surveillez la température corporelle\n");
        }
        if (symptoms.contains("perte d'appétit")) {
            recommendations.append("4. Encouragez l'alimentation avec des aliments appétissants\n");
        }
        
        return recommendations.toString();
    }
    
    private Double calculateConfidence(String breed, List<String> symptoms, List<VeterinaryConsultation> similarConsultations) {
        if (similarConsultations.isEmpty()) {
            return 0.3; // Faible confiance sans données historiques
        }
        
        long totalSimilarSymptoms = similarConsultations.stream()
                .mapToLong(consultation -> consultation.getSymptoms().stream()
                        .filter(symptoms::contains)
                        .count())
                .sum();
        
        double confidence = Math.min(0.9, 0.3 + (totalSimilarSymptoms * 0.1));
        return confidence;
    }
    
    private String generateResponse(String message) {
        String lowerMessage = message.toLowerCase();
        
        if (lowerMessage.contains("bonjour") || lowerMessage.contains("salut")) {
            return "Bonjour ! Je suis votre assistant vétérinaire virtuel. Comment puis-je vous aider aujourd'hui ?";
        }
        
        if (lowerMessage.contains("merci")) {
            return "De rien ! N'hésitez pas si vous avez d'autres questions sur la santé de votre animal.";
        }
        
        if (lowerMessage.contains("aide") || lowerMessage.contains("help")) {
            return "Je peux vous aider à identifier les problèmes de santé de votre animal. Commencez par me dire la race de votre animal et ses symptômes.";
        }
        
        return "Je comprends votre préoccupation. Pour vous aider au mieux, pouvez-vous me dire la race de votre animal et décrire ses symptômes ?";
    }
    
    private Map<String, Map<String, String>> initializeVeterinaryKnowledge() {
        Map<String, Map<String, String>> knowledge = new HashMap<>();
        
        // Connaissances pour les chiens
        Map<String, String> dogKnowledge = new HashMap<>();
        dogKnowledge.put("fièvre", "Fièvre possible - surveillez la température");
        dogKnowledge.put("perte d'appétit", "Perte d'appétit - vérifiez l'état général");
        dogKnowledge.put("léthargie", "Léthargie - peut indiquer un problème de santé");
        knowledge.put("chien", dogKnowledge);
        
        // Connaissances pour les chats
        Map<String, String> catKnowledge = new HashMap<>();
        catKnowledge.put("fièvre", "Fièvre chez le chat - surveillez attentivement");
        catKnowledge.put("perte d'appétit", "Perte d'appétit chez le chat - consultez rapidement");
        catKnowledge.put("léthargie", "Léthargie chez le chat - peut être grave");
        knowledge.put("chat", catKnowledge);
        
        return knowledge;
    }
    
    private List<String> getDefaultSymptomsForBreed(String breed) {
        List<String> commonSymptoms = Arrays.asList(
                "Fièvre", "Perte d'appétit", "Léthargie", "Vomissements", 
                "Diarrhée", "Toux", "Éternuements", "Difficultés respiratoires"
        );
        
        Map<String, List<String>> breedSpecificSymptoms = new HashMap<>();
        breedSpecificSymptoms.put("chien", Arrays.asList("Bave excessive", "Boiterie", "Grattage excessif"));
        breedSpecificSymptoms.put("chat", Arrays.asList("Ronflement", "Changements de comportement", "Perte de poils"));
        
        List<String> symptoms = new ArrayList<>(commonSymptoms);
        symptoms.addAll(breedSpecificSymptoms.getOrDefault(breed.toLowerCase(), new ArrayList<>()));
        
        return symptoms;
    }
    
    private VeterinaryDiagnosisDto convertToDto(VeterinaryConsultation consultation) {
        return VeterinaryDiagnosisDto.builder()
                .id(consultation.getId().toString())
                .animalBreed(consultation.getAnimalBreed())
                .symptoms(consultation.getSymptoms())
                .diagnosis(consultation.getDiagnosis())
                .recommendation(consultation.getRecommendation())
                .confidence(consultation.getConfidence())
                .createdAt(consultation.getCreatedAt())
                .build();
    }
}
