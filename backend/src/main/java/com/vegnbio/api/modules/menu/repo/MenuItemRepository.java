package com.vegnbio.api.modules.menu.repo;

import com.vegnbio.api.modules.menu.entity.MenuItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface MenuItemRepository extends JpaRepository<MenuItem, Long> {
    
    List<MenuItem> findByMenuId(Long menuId);
    
    List<MenuItem> findByNameContainingIgnoreCase(String name);
    
    @Query("SELECT DISTINCT mi FROM MenuItem mi LEFT JOIN FETCH mi.allergens " +
           "JOIN mi.menu m JOIN m.restaurant r WHERE r.code = :restaurantCode")
    List<MenuItem> findByRestaurantCode(@Param("restaurantCode") String restaurantCode);
    
    @Query("SELECT DISTINCT mi FROM MenuItem mi LEFT JOIN FETCH mi.allergens WHERE mi.menu.id = :menuId")
    List<MenuItem> findByMenuIdWithAllergens(@Param("menuId") Long menuId);
}
