package com.vegnbio.api.modules.caisse.dto;

public record TicketLineDto(
        Long id,
        Long ticketId,
        Long menuItemId,
        String menuItemName,
        Integer qty,
        Integer unitPriceCents,
        Integer lineTotalCents
) {}
