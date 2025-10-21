package com.vegnbio.api.modules.room.dto;

public class UpdateRoomRequest {
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
    private String status;
    
    public UpdateRoomRequest() {}
    
    // Getters and Setters
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
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
