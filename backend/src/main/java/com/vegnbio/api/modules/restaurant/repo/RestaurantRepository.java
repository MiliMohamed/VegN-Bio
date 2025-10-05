package com.vegnbio.api.modules.restaurant.repo;

import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RestaurantRepository extends JpaRepository<Restaurant, Long> {
  Optional<Restaurant> findByCode(String code);
}



