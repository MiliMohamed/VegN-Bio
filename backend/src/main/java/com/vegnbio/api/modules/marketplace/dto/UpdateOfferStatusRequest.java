package com.vegnbio.api.modules.marketplace.dto;

import com.vegnbio.api.modules.marketplace.entity.OfferStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateOfferStatusRequest(
        @NotNull OfferStatus status
) {}
