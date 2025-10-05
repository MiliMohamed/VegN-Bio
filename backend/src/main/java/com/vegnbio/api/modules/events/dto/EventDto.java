package com.vegnbio.api.modules.events.dto;

import com.vegnbio.api.modules.events.entity.EventStatus;

import java.time.LocalDateTime;

public record EventDto(
        Long id,
        Long restaurantId,
        String title,
        String type,
        LocalDateTime dateStart,
        LocalDateTime dateEnd,
        Integer capacity,
        String description,
        EventStatus status,
        Integer availableSpots
) {}
