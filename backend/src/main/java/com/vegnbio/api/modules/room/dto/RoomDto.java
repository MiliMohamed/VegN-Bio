package com.vegnbio.api.modules.room.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomDto {
    private Long id;
    private Long restaurantId;
    private String restaurantName;
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomReservationDto {
    private Long id;
    private Long roomId;
    private String roomName;
    private Long userId;
    private String userName;
    private LocalDateTime reservationDate;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String purpose;
    private Integer attendeesCount;
    private String specialRequirements;
    private String status;
    private Long totalPriceCents;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String notes;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateRoomRequest {
    private Long restaurantId;
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateRoomRequest {
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
    private String status;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateReservationRequest {
    private Long roomId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String purpose;
    private Integer attendeesCount;
    private String specialRequirements;
    private String notes;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateReservationRequest {
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String purpose;
    private Integer attendeesCount;
    private String specialRequirements;
    private String status;
    private String notes;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomAvailabilityDto {
    private Long roomId;
    private String roomName;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Boolean available;
    private String reason;
}
