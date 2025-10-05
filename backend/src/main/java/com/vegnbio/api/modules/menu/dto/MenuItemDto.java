package com.vegnbio.api.modules.menu.dto;

import com.vegnbio.api.modules.allergen.dto.AllergenDto;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.util.List;

public record MenuItemDto(
        Long id,
        @NotBlank String name,
        String description,
        @NotNull @Positive Integer priceCents,
        @NotNull Boolean isVegan,
        List<AllergenDto> allergens
) {}
