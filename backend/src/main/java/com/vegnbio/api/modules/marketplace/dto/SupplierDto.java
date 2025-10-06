package com.vegnbio.api.modules.marketplace.dto;

import com.vegnbio.api.modules.marketplace.entity.SupplierStatus;

import java.time.LocalDateTime;

public record SupplierDto(
        Long id,
        String companyName,
        String contactEmail,
        String contactPhone,
        String address,
        String city,
        String description,
        SupplierStatus status,
        LocalDateTime createdAt
) {}
