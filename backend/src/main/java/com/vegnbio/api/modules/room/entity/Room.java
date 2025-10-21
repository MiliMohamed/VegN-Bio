package com.vegnbio.api.modules.room.entity;

import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rooms")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;
    
    @Column(nullable = false)
    private String name;
    
    @Column
    private String description;
    
    @Column(name = "capacity", nullable = false)
    private Integer capacity;
    
    @Column(name = "hourly_rate_cents")
    private Long hourlyRateCents;
    
    @Column(name = "has_wifi")
    @Builder.Default
    private Boolean hasWifi = false;
    
    @Column(name = "has_printer")
    @Builder.Default
    private Boolean hasPrinter = false;
    
    @Column(name = "has_projector")
    @Builder.Default
    private Boolean hasProjector = false;
    
    @Column(name = "has_whiteboard")
    @Builder.Default
    private Boolean hasWhiteboard = false;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private RoomStatus status = RoomStatus.AVAILABLE;
    
    @Column(nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column
    private LocalDateTime updatedAt;
    
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<RoomReservation> reservations = new ArrayList<>();
    
    public enum RoomStatus {
        AVAILABLE, MAINTENANCE, OUT_OF_ORDER
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
