package com.vegnbio.api.modules.caisse.dto;

import jakarta.validation.constraints.NotNull;

public record CreateTicketRequest(
        @NotNull Long restaurantId
) {}
