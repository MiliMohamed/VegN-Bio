package com.vegnbio.api.modules.menu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.util.List;

public record CreateMenuItemRequest(
        @NotNull Long menuId,
        @NotBlank String name,
        String description,
        @NotNull @Positive Integer priceCents,
        @NotNull Boolean isVegan,
        List<Long> allergenIds
) {}
