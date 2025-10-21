package com.vegnbio.api.modules.chatbot.service;

import com.vegnbio.api.modules.chatbot.dto.*;
import com.vegnbio.api.modules.chatbot.entity.VeterinaryConsultation;
import com.vegnbio.api.modules.chatbot.repo.VeterinaryConsultationRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.annotation.PostConstruct;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class ChatbotService {
    
    private static final Logger log = LoggerFactory.getLogger(ChatbotService.class);
    private final VeterinaryConsultationRepository consultationRepository;
    
    // Cache pour améliorer les performances
    private final Map<String, List<String>> breedSymptomsCache = new ConcurrentHashMap<>();
    private final Map<String, List<String>> supportedBreedsCache = new ConcurrentHashMap<>();
    
    // Système d'apprentissage basé sur les consultations
    private final Map<String, Map<String, Integer>> symptomDiagnosisPatterns = new ConcurrentHashMap<>();
    private final Map<String, Double> breedConfidenceScores = new ConcurrentHashMap<>();
    
    public ChatbotService(VeterinaryConsultationRepository consultationRepository) {
        this.consultationRepository = consultationRepository;
    }
    
    @PostConstruct
    public void initializeLearningSystem() {
        log.info("Initializing veterinary learning system...");
        
        try {
            // Charger les données existantes pour l'apprentissage de manière asynchrone
            initializeLearningDataAsync();
            log.info("Learning system initialization started");
        } catch (Exception e) {
            log.warn("Failed to initialize learning system: {}", e.getMessage());
            // Continue without failing the application startup
        }
    }
    
    private void initializeLearningDataAsync() {
        try {
            List<VeterinaryConsultation> existingConsultations = consultationRepository.findAll();
            for (VeterinaryConsultation consultation : existingConsultations) {
                improveLearningFromConsultation(consultation);
            }
            log.info("Learning system initialized with {} consultations", existingConsultations.size());
        } catch (Exception e) {
            log.warn("Failed to load existing consultations: {}", e.getMessage());
        }
    }
    
    // Base de données de connaissances vétérinaires enrichie
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
        // Vérifier le cache d'abord
        if (breedSymptomsCache.containsKey(breed)) {
            return breedSymptomsCache.get(breed);
        }
        
        List<String> symptoms = consultationRepository.findDistinctSymptomsByBreed(breed);
        
        // Ajouter des symptômes communs si la base de données est vide
        if (symptoms.isEmpty()) {
            symptoms = getDefaultSymptomsForBreed(breed);
        }
        
        // Mettre en cache pour améliorer les performances
        breedSymptomsCache.put(breed, symptoms);
        
        return symptoms;
    }
    
    // Nouvelle méthode pour obtenir des recommandations préventives
    public List<String> getPreventiveRecommendations(String breed) {
        List<String> recommendations = new ArrayList<>();
        
        switch (breed.toLowerCase()) {
            case "chien":
                recommendations.addAll(Arrays.asList(
                    "Vaccination annuelle contre la rage et les maladies courantes",
                    "Vermifugation régulière (tous les 3 mois)",
                    "Brossage des dents quotidien pour éviter les problèmes dentaires",
                    "Exercice régulier pour maintenir un poids santé",
                    "Surveillance des oreilles pour éviter les infections"
                ));
                break;
            case "chat":
                recommendations.addAll(Arrays.asList(
                    "Vaccination annuelle contre le typhus et le coryza",
                    "Vermifugation régulière (tous les 3 mois)",
                    "Stérilisation recommandée pour éviter les problèmes de reproduction",
                    "Surveillance des reins avec une alimentation adaptée",
                    "Brossage régulier pour éviter les boules de poils"
                ));
                break;
            case "lapin":
                recommendations.addAll(Arrays.asList(
                    "Alimentation riche en foin pour l'usure des dents",
                    "Surveillance des dents qui poussent continuellement",
                    "Environnement propre pour éviter les problèmes respiratoires",
                    "Vaccination contre la myxomatose et la maladie hémorragique",
                    "Surveillance du poids pour éviter l'obésité"
                ));
                break;
            default:
                recommendations.addAll(Arrays.asList(
                    "Consultation vétérinaire régulière",
                    "Surveillance du comportement et de l'appétit",
                    "Environnement propre et adapté",
                    "Alimentation équilibrée et appropriée"
                ));
        }
        
        return recommendations;
    }
    
    // Nouvelle méthode pour obtenir des statistiques d'apprentissage
    public Map<String, Object> getLearningStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        long totalConsultations = consultationRepository.count();
        List<String> breeds = consultationRepository.findDistinctAnimalBreeds();
        List<String> symptoms = consultationRepository.findDistinctSymptoms();
        
        stats.put("totalConsultations", totalConsultations);
        stats.put("supportedBreeds", breeds.size());
        stats.put("knownSymptoms", symptoms.size());
        stats.put("averageConfidence", calculateAverageConfidence());
        stats.put("mostCommonBreeds", getMostCommonBreeds());
        stats.put("mostCommonSymptoms", getMostCommonSymptoms());
        
        return stats;
    }
    
    // Méthode pour améliorer le système d'apprentissage
    @Transactional(rollbackFor = Exception.class)
    public void improveLearningFromConsultation(VeterinaryConsultation consultation) {
        String breed = consultation.getAnimalBreed().toLowerCase();
        
        // Mettre à jour les patterns de symptômes-diagnostic
        for (String symptom : consultation.getSymptoms()) {
            String key = breed + "_" + symptom.toLowerCase();
            Map<String, Integer> patterns = symptomDiagnosisPatterns.computeIfAbsent(key, k -> new HashMap<>());
            patterns.merge(consultation.getDiagnosis(), 1, Integer::sum);
        }
        
        // Mettre à jour les scores de confiance par race
        breedConfidenceScores.merge(breed, consultation.getConfidence(), 
            (existing, newValue) -> (existing + newValue) / 2);
        
        // Invalider le cache pour cette race
        breedSymptomsCache.remove(breed);
        
        log.info("Learning system updated with consultation for breed: {}", breed);
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
        dogKnowledge.put("vomissements", "Vomissements - surveillez la fréquence et la couleur");
        dogKnowledge.put("diarrhée", "Diarrhée - vérifiez l'hydratation");
        dogKnowledge.put("toux", "Toux - peut indiquer une infection respiratoire");
        knowledge.put("chien", dogKnowledge);
        
        // Connaissances pour les chats
        Map<String, String> catKnowledge = new HashMap<>();
        catKnowledge.put("fièvre", "Fièvre chez le chat - surveillez attentivement");
        catKnowledge.put("perte d'appétit", "Perte d'appétit chez le chat - consultez rapidement");
        catKnowledge.put("léthargie", "Léthargie chez le chat - peut être grave");
        catKnowledge.put("vomissements", "Vomissements chez le chat - surveillez les boules de poils");
        catKnowledge.put("difficultés urinaires", "Difficultés urinaires - urgence vétérinaire");
        catKnowledge.put("perte de poils", "Perte de poils - peut être due au stress ou à une maladie");
        knowledge.put("chat", catKnowledge);
        
        // Connaissances pour les lapins
        Map<String, String> rabbitKnowledge = new HashMap<>();
        rabbitKnowledge.put("perte d'appétit", "Perte d'appétit chez le lapin - urgence vétérinaire");
        rabbitKnowledge.put("léthargie", "Léthargie chez le lapin - surveillez attentivement");
        rabbitKnowledge.put("difficultés respiratoires", "Difficultés respiratoires - infection possible");
        rabbitKnowledge.put("diarrhée", "Diarrhée chez le lapin - problème digestif grave");
        knowledge.put("lapin", rabbitKnowledge);
        
        return knowledge;
    }
    
    // Méthodes utilitaires pour le système d'apprentissage
    
    private Double calculateAverageConfidence() {
        List<VeterinaryConsultation> consultations = consultationRepository.findAll();
        if (consultations.isEmpty()) {
            return 0.0;
        }
        
        double totalConfidence = consultations.stream()
            .mapToDouble(VeterinaryConsultation::getConfidence)
            .sum();
        
        return totalConfidence / consultations.size();
    }
    
    private List<Map<String, Object>> getMostCommonBreeds() {
        List<VeterinaryConsultation> consultations = consultationRepository.findAll();
        Map<String, Long> breedCounts = consultations.stream()
            .collect(Collectors.groupingBy(
                VeterinaryConsultation::getAnimalBreed,
                Collectors.counting()
            ));
        
        return breedCounts.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
            .limit(5)
            .map(entry -> {
                Map<String, Object> breedInfo = new HashMap<>();
                breedInfo.put("breed", entry.getKey());
                breedInfo.put("count", entry.getValue());
                return breedInfo;
            })
            .collect(Collectors.toList());
    }
    
    private List<Map<String, Object>> getMostCommonSymptoms() {
        List<VeterinaryConsultation> consultations = consultationRepository.findAll();
        Map<String, Long> symptomCounts = consultations.stream()
            .flatMap(consultation -> consultation.getSymptoms().stream())
            .collect(Collectors.groupingBy(
                symptom -> symptom,
                Collectors.counting()
            ));
        
        return symptomCounts.entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
            .limit(10)
            .map(entry -> {
                Map<String, Object> symptomInfo = new HashMap<>();
                symptomInfo.put("symptom", entry.getKey());
                symptomInfo.put("count", entry.getValue());
                return symptomInfo;
            })
            .collect(Collectors.toList());
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
