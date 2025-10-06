package com.vegnbio.api.modules.marketplace.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateSupplierRequest(
        @NotBlank String companyName,
        @NotBlank @Email String contactEmail,
        String contactPhone,
        String address,
        String city,
        String description
) {}
