package com.vegnbio.api.modules.room.dto;

public class CreateRoomRequest {
    private Long restaurantId;
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
    
    public CreateRoomRequest() {}
    
    // Getters and Setters
    public Long getRestaurantId() { return restaurantId; }
    public void setRestaurantId(Long restaurantId) { this.restaurantId = restaurantId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    
    public Long getHourlyRateCents() { return hourlyRateCents; }
    public void setHourlyRateCents(Long hourlyRateCents) { this.hourlyRateCents = hourlyRateCents; }
    
    public Boolean getHasWifi() { return hasWifi; }
    public void setHasWifi(Boolean hasWifi) { this.hasWifi = hasWifi; }
    
    public Boolean getHasPrinter() { return hasPrinter; }
    public void setHasPrinter(Boolean hasPrinter) { this.hasPrinter = hasPrinter; }
    
    public Boolean getHasProjector() { return hasProjector; }
    public void setHasProjector(Boolean hasProjector) { this.hasProjector = hasProjector; }
    
    public Boolean getHasWhiteboard() { return hasWhiteboard; }
    public void setHasWhiteboard(Boolean hasWhiteboard) { this.hasWhiteboard = hasWhiteboard; }
}
