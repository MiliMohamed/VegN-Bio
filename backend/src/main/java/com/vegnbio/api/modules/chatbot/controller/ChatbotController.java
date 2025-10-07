package com.vegnbio.api.modules.chatbot.controller;

import com.vegnbio.api.modules.chatbot.dto.*;
import com.vegnbio.api.modules.chatbot.service.ChatbotService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/chatbot")
@RequiredArgsConstructor
public class ChatbotController {
    
    private final ChatbotService chatbotService;
    
    @PostMapping("/chat")
    public ResponseEntity<ChatMessageDto> sendMessage(@Valid @RequestBody ChatRequest request) {
        ChatMessageDto response = chatbotService.sendMessage(request);
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/diagnosis")
    public ResponseEntity<VeterinaryDiagnosisDto> getVeterinaryDiagnosis(@Valid @RequestBody DiagnosisRequest request) {
        VeterinaryDiagnosisDto diagnosis = chatbotService.getVeterinaryDiagnosis(request);
        return ResponseEntity.ok(diagnosis);
    }
    
    @PostMapping("/recommendations")
    public ResponseEntity<List<String>> getRecommendations(@Valid @RequestBody DiagnosisRequest request) {
        List<String> recommendations = chatbotService.getRecommendations(request);
        return ResponseEntity.ok(recommendations);
    }
    
    @PostMapping("/consultations")
    public ResponseEntity<Void> saveConsultation(@Valid @RequestBody ConsultationRequest request) {
        chatbotService.saveConsultation(request);
        return ResponseEntity.ok().build();
    }
    
    @GetMapping("/consultations")
    public ResponseEntity<List<VeterinaryDiagnosisDto>> getConsultationHistory(
            @RequestParam(required = false) String userId) {
        List<VeterinaryDiagnosisDto> history = chatbotService.getConsultationHistory(userId);
        return ResponseEntity.ok(history);
    }
    
    @GetMapping("/breeds")
    public ResponseEntity<Map<String, List<String>>> getSupportedBreeds() {
        List<String> breeds = chatbotService.getSupportedBreeds();
        return ResponseEntity.ok(Map.of("breeds", breeds));
    }
    
    @GetMapping("/symptoms/{breed}")
    public ResponseEntity<Map<String, List<String>>> getCommonSymptoms(@PathVariable String breed) {
        List<String> symptoms = chatbotService.getCommonSymptoms(breed);
        return ResponseEntity.ok(Map.of("symptoms", symptoms));
    }
}
