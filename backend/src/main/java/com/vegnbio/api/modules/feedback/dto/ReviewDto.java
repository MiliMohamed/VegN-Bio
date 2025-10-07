package com.vegnbio.api.modules.feedback.dto;

import com.vegnbio.api.modules.feedback.entity.ReviewStatus;

import java.time.LocalDateTime;

public record ReviewDto(
        Long id,
        Long restaurantId,
        String customerName,
        String customerEmail,
        Integer rating,
        String comment,
        ReviewStatus status,
        LocalDateTime createdAt
) {}

