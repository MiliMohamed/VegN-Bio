package com.vegnbio.api.modules.menu.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.util.List;

public record CreateMenuRequest(
        @NotNull Long restaurantId,
        @NotBlank String title,
        LocalDate activeFrom,
        LocalDate activeTo
) {}
