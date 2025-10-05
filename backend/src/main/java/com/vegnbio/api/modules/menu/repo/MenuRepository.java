package com.vegnbio.api.modules.menu.repo;

import com.vegnbio.api.modules.menu.entity.Menu;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface MenuRepository extends JpaRepository<Menu, Long> {
    
    List<Menu> findByRestaurant(Restaurant restaurant);
    
    @Query("SELECT m FROM Menu m WHERE m.restaurant = :restaurant AND " +
           "(:date IS NULL OR (m.activeFrom IS NULL OR m.activeFrom <= :date) AND " +
           "(m.activeTo IS NULL OR m.activeTo >= :date))")
    List<Menu> findByRestaurantAndDate(@Param("restaurant") Restaurant restaurant, 
                                      @Param("date") LocalDate date);
}
