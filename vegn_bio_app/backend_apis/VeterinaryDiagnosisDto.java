package com.vegnbio.restaurant.dto;

import java.util.List;

public record VeterinaryDiagnosisDto(
    String animalBreed,
    String animalSpecies,
    Integer animalAge,
    String animalGender,
    List<String> symptoms,
    
    // Réponse du diagnostic
    String diagnosis,
    String treatment,
    Double confidence,
    String veterinarianName,
    String consultationDate
) {}
