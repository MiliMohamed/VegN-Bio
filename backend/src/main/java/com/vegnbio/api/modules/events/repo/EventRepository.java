package com.vegnbio.api.modules.events.repo;

import com.vegnbio.api.modules.events.entity.Event;
import com.vegnbio.api.modules.events.entity.EventStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface EventRepository extends JpaRepository<Event, Long> {
    
    List<Event> findByRestaurantIdAndStatus(Long restaurantId, EventStatus status);
    
    @Query("SELECT e FROM Event e WHERE e.restaurant.id = :restaurantId " +
           "AND e.dateStart >= :from " +
           "AND e.dateStart <= :to " +
           "AND e.status = :status")
    List<Event> findByRestaurantIdAndDateRangeAndStatus(
            @Param("restaurantId") Long restaurantId,
            @Param("from") LocalDateTime from,
            @Param("to") LocalDateTime to,
            @Param("status") EventStatus status
    );
    
    List<Event> findByRestaurantId(Long restaurantId);
    
    @Query("SELECT e FROM Event e WHERE e.dateStart >= :from AND e.status = 'ACTIVE'")
    List<Event> findActiveEventsFromDate(@Param("from") LocalDateTime from);
}
