package com.vegnbio.restaurant.dto;

import java.time.LocalDateTime;
import java.util.List;

public record VeterinaryConsultationDto(
    Long id,
    String animalBreed,
    String animalSpecies,
    Integer animalAge,
    String animalGender,
    List<String> symptoms,
    String diagnosis,
    String treatment,
    String veterinarianName,
    LocalDateTime consultationDate,
    Double confidence
) {}
