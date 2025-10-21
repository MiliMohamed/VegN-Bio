package com.vegnbio.api.modules.events.entity;

import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "events")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class Event {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;
    
    @Column(nullable = false)
    private String title;
    
    @Column
    private String type;
    
    @Column(name = "date_start", nullable = false)
    private LocalDateTime dateStart;
    
    @Column(name = "date_end")
    private LocalDateTime dateEnd;
    
    @Column
    private Integer capacity;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private EventStatus status = EventStatus.ACTIVE;
    
    @PrePersist
    protected void onCreate() {
        if (status == null) {
            status = EventStatus.ACTIVE;
        }
    }
}
