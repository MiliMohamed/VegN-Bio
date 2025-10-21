package com.vegnbio.api.modules.room.repository;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.room.entity.RoomReservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RoomReservationRepository extends JpaRepository<RoomReservation, Long> {
    
    List<RoomReservation> findByUser(User user);
    
    List<RoomReservation> findByRoomId(Long roomId);
    
    @Query("SELECT rr FROM RoomReservation rr WHERE rr.room.id = :roomId AND rr.status IN ('PENDING', 'CONFIRMED')")
    List<RoomReservation> findActiveReservationsByRoom(@Param("roomId") Long roomId);
    
    @Query("SELECT rr FROM RoomReservation rr WHERE rr.room.id = :roomId AND rr.status IN ('PENDING', 'CONFIRMED') " +
           "AND ((rr.startTime <= :endTime AND rr.endTime >= :startTime))")
    List<RoomReservation> findConflictingReservations(@Param("roomId") Long roomId, 
                                                      @Param("startTime") LocalDateTime startTime, 
                                                      @Param("endTime") LocalDateTime endTime);
    
    @Query("SELECT rr FROM RoomReservation rr WHERE rr.room.id = :roomId AND rr.status IN ('PENDING', 'CONFIRMED') " +
           "AND rr.id != :excludeId AND ((rr.startTime <= :endTime AND rr.endTime >= :startTime))")
    List<RoomReservation> findConflictingReservationsExcluding(@Param("roomId") Long roomId, 
                                                               @Param("startTime") LocalDateTime startTime, 
                                                               @Param("endTime") LocalDateTime endTime,
                                                               @Param("excludeId") Long excludeId);
    
    @Query("SELECT rr FROM RoomReservation rr WHERE rr.room.restaurant.id = :restaurantId AND rr.status IN ('PENDING', 'CONFIRMED')")
    List<RoomReservation> findActiveReservationsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    @Query("SELECT rr FROM RoomReservation rr WHERE rr.user.id = :userId AND rr.status IN ('PENDING', 'CONFIRMED')")
    List<RoomReservation> findActiveReservationsByUser(@Param("userId") Long userId);
}
