package com.vegnbio.api.modules.marketplace.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record CreateOfferRequest(
        @NotNull Long supplierId,
        @NotBlank String title,
        String description,
        @PositiveOrZero @NotNull Integer unitPriceCents,
        @NotBlank String unit
) {}
