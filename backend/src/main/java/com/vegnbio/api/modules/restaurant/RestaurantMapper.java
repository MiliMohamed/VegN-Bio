package com.vegnbio.api.modules.restaurant;

import com.vegnbio.api.modules.restaurant.dto.RestaurantDto;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;

/**
 * Mapper pour convertir les entités Restaurant en DTOs
 * 
 * @author VegN-Bio Team
 */
public class RestaurantMapper {
  public static RestaurantDto toDto(Restaurant r){
    return new RestaurantDto(
      r.getId(), 
      r.getName(), 
      r.getCode(), 
      r.getAddress(), 
      r.getCity(), 
      r.getPhone(), 
      r.getEmail(),
      r.getWifiAvailable(),
      r.getMeetingRoomsCount(),
      r.getRestaurantCapacity(),
      r.getPrinterAvailable(),
      r.getMemberTrays(),
      r.getDeliveryAvailable(),
      r.getSpecialEvents(),
      r.getMondayThursdayHours(),
      r.getFridayHours(),
      r.getSaturdayHours(),
      r.getSundayHours()
    );
  }
}



