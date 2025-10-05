package com.vegnbio.api.modules.events.dto;

import com.vegnbio.api.modules.events.entity.BookingStatus;

import java.time.LocalDateTime;

public record BookingDto(
        Long id,
        Long eventId,
        String customerName,
        String customerPhone,
        Integer pax,
        BookingStatus status,
        LocalDateTime createdAt
) {}
