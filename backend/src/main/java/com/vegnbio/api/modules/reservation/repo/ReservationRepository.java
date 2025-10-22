package com.vegnbio.api.modules.reservation.repo;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.reservation.entity.Reservation;
import com.vegnbio.api.modules.reservation.entity.Reservation.ReservationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    
    List<Reservation> findByUser(User user);
    
    List<Reservation> findByRestaurantId(Long restaurantId);
    
    List<Reservation> findByStatus(ReservationStatus status);
    
    @Query("SELECT r FROM Reservation r WHERE r.restaurant.id = :restaurantId AND r.reservationDate = :date AND r.status IN ('PENDING', 'CONFIRMED')")
    List<Reservation> findActiveReservationsByRestaurantAndDate(@Param("restaurantId") Long restaurantId, @Param("date") LocalDate date);
    
    @Query("SELECT r FROM Reservation r WHERE r.user.id = :userId AND r.status IN ('PENDING', 'CONFIRMED')")
    List<Reservation> findActiveReservationsByUser(@Param("userId") Long userId);
    
    @Query("SELECT r FROM Reservation r WHERE r.event.id = :eventId")
    List<Reservation> findByEventId(@Param("eventId") Long eventId);
    
    @Query("SELECT r FROM Reservation r WHERE r.event IS NOT NULL")
    List<Reservation> findEventReservations();
    
    @Query("SELECT r FROM Reservation r WHERE r.event IS NULL")
    List<Reservation> findTableReservations();
}
