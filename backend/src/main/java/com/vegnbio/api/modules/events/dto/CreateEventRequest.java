package com.vegnbio.api.modules.events.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDateTime;

public record CreateEventRequest(
        @NotNull Long restaurantId,
        @NotBlank String title,
        String type,
        @NotNull LocalDateTime dateStart,
        LocalDateTime dateEnd,
        @Positive Integer capacity,
        String description
) {}
