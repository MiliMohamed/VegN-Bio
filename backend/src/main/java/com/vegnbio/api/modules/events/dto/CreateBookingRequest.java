package com.vegnbio.api.modules.events.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateBookingRequest(
        @NotNull Long eventId,
        @NotBlank String customerName,
        String customerPhone,
        @Positive @NotNull Integer pax
) {}
