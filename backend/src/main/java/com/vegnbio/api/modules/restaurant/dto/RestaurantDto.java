package com.vegnbio.api.modules.restaurant.dto;

public record RestaurantDto(
  Long id, 
  String name, 
  String code, 
  String address, 
  String city, 
  String phone, 
  String email,
  Boolean wifiAvailable,
  Integer meetingRoomsCount,
  Integer restaurantCapacity,
  Boolean printerAvailable,
  Boolean memberTrays,
  Boolean deliveryAvailable,
  String specialEvents,
  String mondayThursdayHours,
  String fridayHours,
  String saturdayHours,
  String sundayHours
) {}



