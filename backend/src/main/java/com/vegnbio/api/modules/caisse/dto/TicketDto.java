package com.vegnbio.api.modules.caisse.dto;

import com.vegnbio.api.modules.caisse.entity.TicketStatus;

import java.time.LocalDateTime;
import java.util.List;

public record TicketDto(
        Long id,
        Long restaurantId,
        LocalDateTime openedAt,
        LocalDateTime closedAt,
        Integer totalCents,
        TicketStatus status,
        List<TicketLineDto> ticketLines
) {}
