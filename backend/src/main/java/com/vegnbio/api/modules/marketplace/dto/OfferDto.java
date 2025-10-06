package com.vegnbio.api.modules.marketplace.dto;

import com.vegnbio.api.modules.marketplace.entity.OfferStatus;

import java.time.LocalDateTime;

public record OfferDto(
        Long id,
        Long supplierId,
        String supplierName,
        String title,
        String description,
        Integer unitPriceCents,
        String unit,
        OfferStatus status,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
) {}
