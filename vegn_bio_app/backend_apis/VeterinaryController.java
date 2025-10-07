package com.vegnbio.restaurant.controller;

import com.vegnbio.restaurant.dto.VeterinaryConsultationDto;
import com.vegnbio.restaurant.dto.VeterinaryDiagnosisDto;
import com.vegnbio.restaurant.service.VeterinaryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/veterinary")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class VeterinaryController {

    private final VeterinaryService veterinaryService;

    /**
     * Récupère toutes les consultations vétérinaires
     */
    @GetMapping("/consultations")
    public ResponseEntity<List<VeterinaryConsultationDto>> getAllConsultations() {
        return ResponseEntity.ok(veterinaryService.getAllConsultations());
    }

    /**
     * Récupère les espèces disponibles
     */
    @GetMapping("/species")
    public ResponseEntity<List<String>> getAvailableSpecies() {
        return ResponseEntity.ok(veterinaryService.getAvailableSpecies());
    }

    /**
     * Récupère les races disponibles pour une espèce
     */
    @GetMapping("/breeds/{species}")
    public ResponseEntity<List<String>> getAvailableBreeds(@PathVariable String species) {
        return ResponseEntity.ok(veterinaryService.getAvailableBreeds(species));
    }

    /**
     * Récupère les symptômes courants pour une race
     */
    @GetMapping("/symptoms/{species}/{breed}")
    public ResponseEntity<List<String>> getCommonSymptoms(
            @PathVariable String species, 
            @PathVariable String breed) {
        return ResponseEntity.ok(veterinaryService.getCommonSymptoms(species, breed));
    }

    /**
     * Demande un diagnostic basé sur les symptômes
     */
    @PostMapping("/diagnosis")
    public ResponseEntity<VeterinaryDiagnosisDto> requestDiagnosis(@RequestBody VeterinaryDiagnosisDto diagnosisRequest) {
        return ResponseEntity.ok(veterinaryService.getDiagnosis(diagnosisRequest));
    }

    /**
     * Ajoute une nouvelle consultation (pour l'apprentissage)
     */
    @PostMapping("/consultations")
    public ResponseEntity<VeterinaryConsultationDto> addConsultation(@RequestBody VeterinaryConsultationDto consultation) {
        return ResponseEntity.ok(veterinaryService.addConsultation(consultation));
    }
}
