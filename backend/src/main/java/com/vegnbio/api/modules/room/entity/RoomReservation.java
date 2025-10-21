package com.vegnbio.api.modules.room.entity;

import com.vegnbio.api.modules.auth.entity.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "room_reservations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class RoomReservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(name = "reservation_date", nullable = false)
    private LocalDateTime reservationDate;
    
    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;
    
    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;
    
    @Column(name = "purpose")
    private String purpose;
    
    @Column(name = "attendees_count")
    private Integer attendeesCount;
    
    @Column(name = "special_requirements")
    private String specialRequirements;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private ReservationStatus status = ReservationStatus.PENDING;
    
    @Column(name = "total_price_cents")
    private Long totalPriceCents;
    
    @Column(nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column
    private LocalDateTime updatedAt;
    
    @Column
    private String notes;
    
    public enum ReservationStatus {
        PENDING, CONFIRMED, CANCELLED, COMPLETED, NO_SHOW
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    public long calculateDurationInHours() {
        return java.time.Duration.between(startTime, endTime).toHours();
    }
    
    public long calculateTotalPrice() {
        if (room.getHourlyRateCents() == null) {
            return 0L;
        }
        return calculateDurationInHours() * room.getHourlyRateCents();
    }
}
