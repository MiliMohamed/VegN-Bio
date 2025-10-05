package com.vegnbio.api.modules.caisse.repo;

import com.vegnbio.api.modules.caisse.entity.Ticket;
import com.vegnbio.api.modules.caisse.entity.TicketStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface TicketRepository extends JpaRepository<Ticket, Long> {
    
    List<Ticket> findByRestaurantIdAndStatus(Long restaurantId, TicketStatus status);
    
    @Query("SELECT t FROM Ticket t WHERE t.restaurant.id = :restaurantId " +
           "AND (:from IS NULL OR t.openedAt >= :from) " +
           "AND (:to IS NULL OR t.openedAt <= :to)")
    List<Ticket> findByRestaurantIdAndDateRange(
            @Param("restaurantId") Long restaurantId,
            @Param("from") LocalDateTime from,
            @Param("to") LocalDateTime to
    );
    
    List<Ticket> findByRestaurantId(Long restaurantId);
}
