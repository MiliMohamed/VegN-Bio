package com.vegnbio.api.modules.room.dto;

import java.time.LocalDateTime;

public class RoomAvailabilityDto {
    private Long roomId;
    private String roomName;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Boolean available;
    private String reason;
    
    public RoomAvailabilityDto() {}
    
    public RoomAvailabilityDto(Long roomId, String roomName, LocalDateTime startTime, LocalDateTime endTime,
                              Boolean available, String reason) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.available = available;
        this.reason = reason;
    }
    
    public static RoomAvailabilityDtoBuilder builder() {
        return new RoomAvailabilityDtoBuilder();
    }
    
    public static class RoomAvailabilityDtoBuilder {
        private Long roomId;
        private String roomName;
        private LocalDateTime startTime;
        private LocalDateTime endTime;
        private Boolean available;
        private String reason;
        
        public RoomAvailabilityDtoBuilder roomId(Long roomId) {
            this.roomId = roomId;
            return this;
        }
        
        public RoomAvailabilityDtoBuilder roomName(String roomName) {
            this.roomName = roomName;
            return this;
        }
        
        public RoomAvailabilityDtoBuilder startTime(LocalDateTime startTime) {
            this.startTime = startTime;
            return this;
        }
        
        public RoomAvailabilityDtoBuilder endTime(LocalDateTime endTime) {
            this.endTime = endTime;
            return this;
        }
        
        public RoomAvailabilityDtoBuilder available(Boolean available) {
            this.available = available;
            return this;
        }
        
        public RoomAvailabilityDtoBuilder reason(String reason) {
            this.reason = reason;
            return this;
        }
        
        public RoomAvailabilityDto build() {
            return new RoomAvailabilityDto(roomId, roomName, startTime, endTime, available, reason);
        }
    }
    
    // Getters and Setters
    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }
    
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    
    public Boolean getAvailable() { return available; }
    public void setAvailable(Boolean available) { this.available = available; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
