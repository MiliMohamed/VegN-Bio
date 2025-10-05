package com.vegnbio.api.modules.events.dto;

import com.vegnbio.api.modules.events.entity.BookingStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateBookingStatusRequest(
        @NotNull BookingStatus status
) {}
