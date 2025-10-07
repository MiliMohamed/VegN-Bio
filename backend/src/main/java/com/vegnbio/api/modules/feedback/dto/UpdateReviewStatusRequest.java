package com.vegnbio.api.modules.feedback.dto;

import com.vegnbio.api.modules.feedback.entity.ReviewStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateReviewStatusRequest(
        @NotNull ReviewStatus status
) {}

