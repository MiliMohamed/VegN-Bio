package com.vegnbio.api.modules.events.repo;

import com.vegnbio.api.modules.events.entity.Booking;
import com.vegnbio.api.modules.events.entity.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    
    List<Booking> findByEventId(Long eventId);
    
    List<Booking> findByEventIdAndStatus(Long eventId, BookingStatus status);
    
    @Query("SELECT SUM(b.pax) FROM Booking b WHERE b.event.id = :eventId AND b.status = 'CONFIRMED'")
    Integer getTotalConfirmedPaxForEvent(@Param("eventId") Long eventId);
    
    @Query("SELECT b FROM Booking b WHERE b.event.restaurant.id = :restaurantId")
    List<Booking> findByRestaurantId(@Param("restaurantId") Long restaurantId);
}
