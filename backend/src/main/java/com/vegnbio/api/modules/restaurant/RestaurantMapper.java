package com.vegnbio.api.modules.restaurant;

import com.vegnbio.api.modules.restaurant.dto.RestaurantDto;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;

public class RestaurantMapper {
  public static RestaurantDto toDto(Restaurant r){
    return new RestaurantDto(r.getId(), r.getName(), r.getCode(), r.getAddress(), r.getCity(), r.getPhone(), r.getEmail());
  }
}



