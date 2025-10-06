package com.vegnbio.api.modules.feedback.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateReviewRequest(
        @NotNull Long restaurantId,
        @NotBlank String customerName,
        @Email String customerEmail,
        @Min(1) @Max(5) @NotNull Integer rating,
        String comment
) {}
