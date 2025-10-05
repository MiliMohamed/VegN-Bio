package com.vegnbio.api.modules.caisse.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record CreateTicketLineRequest(
        @NotNull Long menuItemId,
        @Positive @NotNull Integer qty
) {}
