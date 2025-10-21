package com.vegnbio.api.modules.room.dto;

import java.time.LocalDateTime;

public class RoomDto {
    private Long id;
    private Long restaurantId;
    private String restaurantName;
    private String name;
    private String description;
    private Integer capacity;
    private Long hourlyRateCents;
    private Boolean hasWifi;
    private Boolean hasPrinter;
    private Boolean hasProjector;
    private Boolean hasWhiteboard;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    public RoomDto() {}
    
    public RoomDto(Long id, Long restaurantId, String restaurantName, String name, String description,
                   Integer capacity, Long hourlyRateCents, Boolean hasWifi, Boolean hasPrinter,
                   Boolean hasProjector, Boolean hasWhiteboard, String status, LocalDateTime createdAt,
                   LocalDateTime updatedAt) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.name = name;
        this.description = description;
        this.capacity = capacity;
        this.hourlyRateCents = hourlyRateCents;
        this.hasWifi = hasWifi;
        this.hasPrinter = hasPrinter;
        this.hasProjector = hasProjector;
        this.hasWhiteboard = hasWhiteboard;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    public static RoomDtoBuilder builder() {
        return new RoomDtoBuilder();
    }
    
    public static class RoomDtoBuilder {
        private Long id;
        private Long restaurantId;
        private String restaurantName;
        private String name;
        private String description;
        private Integer capacity;
        private Long hourlyRateCents;
        private Boolean hasWifi;
        private Boolean hasPrinter;
        private Boolean hasProjector;
        private Boolean hasWhiteboard;
        private String status;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        
        public RoomDtoBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public RoomDtoBuilder restaurantId(Long restaurantId) {
            this.restaurantId = restaurantId;
            return this;
        }
        
        public RoomDtoBuilder restaurantName(String restaurantName) {
            this.restaurantName = restaurantName;
            return this;
        }
        
        public RoomDtoBuilder name(String name) {
            this.name = name;
            return this;
        }
        
        public RoomDtoBuilder description(String description) {
            this.description = description;
            return this;
        }
        
        public RoomDtoBuilder capacity(Integer capacity) {
            this.capacity = capacity;
            return this;
        }
        
        public RoomDtoBuilder hourlyRateCents(Long hourlyRateCents) {
            this.hourlyRateCents = hourlyRateCents;
            return this;
        }
        
        public RoomDtoBuilder hasWifi(Boolean hasWifi) {
            this.hasWifi = hasWifi;
            return this;
        }
        
        public RoomDtoBuilder hasPrinter(Boolean hasPrinter) {
            this.hasPrinter = hasPrinter;
            return this;
        }
        
        public RoomDtoBuilder hasProjector(Boolean hasProjector) {
            this.hasProjector = hasProjector;
            return this;
        }
        
        public RoomDtoBuilder hasWhiteboard(Boolean hasWhiteboard) {
            this.hasWhiteboard = hasWhiteboard;
            return this;
        }
        
        public RoomDtoBuilder status(String status) {
            this.status = status;
            return this;
        }
        
        public RoomDtoBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public RoomDtoBuilder updatedAt(LocalDateTime updatedAt) {
            this.updatedAt = updatedAt;
            return this;
        }
        
        public RoomDto build() {
            return new RoomDto(id, restaurantId, restaurantName, name, description, capacity,
                             hourlyRateCents, hasWifi, hasPrinter, hasProjector, hasWhiteboard,
                             status, createdAt, updatedAt);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getRestaurantId() { return restaurantId; }
    public void setRestaurantId(Long restaurantId) { this.restaurantId = restaurantId; }
    
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    
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
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
