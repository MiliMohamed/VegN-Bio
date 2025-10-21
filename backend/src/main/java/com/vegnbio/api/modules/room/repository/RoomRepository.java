package com.vegnbio.api.modules.room.repository;

import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import com.vegnbio.api.modules.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    
    List<Room> findByRestaurant(Restaurant restaurant);
    
    @Query("SELECT r FROM Room r WHERE r.restaurant.id = :restaurantId AND r.status = 'AVAILABLE'")
    List<Room> findAvailableRoomsByRestaurant(@Param("restaurantId") Long restaurantId);
    
    @Query("SELECT r FROM Room r WHERE r.restaurant.id = :restaurantId AND r.capacity >= :minCapacity")
    List<Room> findRoomsByRestaurantAndMinCapacity(@Param("restaurantId") Long restaurantId, @Param("minCapacity") Integer minCapacity);
    
    @Query("SELECT r FROM Room r WHERE r.restaurant.id = :restaurantId AND r.status = 'AVAILABLE' AND r.capacity >= :minCapacity")
    List<Room> findAvailableRoomsByRestaurantAndMinCapacity(@Param("restaurantId") Long restaurantId, @Param("minCapacity") Integer minCapacity);
}
