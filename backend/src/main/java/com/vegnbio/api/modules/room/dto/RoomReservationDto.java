package com.vegnbio.api.modules.room.dto;

import java.time.LocalDateTime;

public class RoomReservationDto {
    private Long id;
    private Long roomId;
    private String roomName;
    private Long userId;
    private String userName;
    private LocalDateTime reservationDate;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String purpose;
    private Integer attendeesCount;
    private String specialRequirements;
    private String status;
    private Long totalPriceCents;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String notes;
    
    public RoomReservationDto() {}
    
    public RoomReservationDto(Long id, Long roomId, String roomName, Long userId, String userName,
                             LocalDateTime reservationDate, LocalDateTime startTime, LocalDateTime endTime,
                             String purpose, Integer attendeesCount, String specialRequirements,
                             String status, Long totalPriceCents, LocalDateTime createdAt,
                             LocalDateTime updatedAt, String notes) {
        this.id = id;
        this.roomId = roomId;
        this.roomName = roomName;
        this.userId = userId;
        this.userName = userName;
        this.reservationDate = reservationDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.purpose = purpose;
        this.attendeesCount = attendeesCount;
        this.specialRequirements = specialRequirements;
        this.status = status;
        this.totalPriceCents = totalPriceCents;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.notes = notes;
    }
    
    public static RoomReservationDtoBuilder builder() {
        return new RoomReservationDtoBuilder();
    }
    
    public static class RoomReservationDtoBuilder {
        private Long id;
        private Long roomId;
        private String roomName;
        private Long userId;
        private String userName;
        private LocalDateTime reservationDate;
        private LocalDateTime startTime;
        private LocalDateTime endTime;
        private String purpose;
        private Integer attendeesCount;
        private String specialRequirements;
        private String status;
        private Long totalPriceCents;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private String notes;
        
        public RoomReservationDtoBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public RoomReservationDtoBuilder roomId(Long roomId) {
            this.roomId = roomId;
            return this;
        }
        
        public RoomReservationDtoBuilder roomName(String roomName) {
            this.roomName = roomName;
            return this;
        }
        
        public RoomReservationDtoBuilder userId(Long userId) {
            this.userId = userId;
            return this;
        }
        
        public RoomReservationDtoBuilder userName(String userName) {
            this.userName = userName;
            return this;
        }
        
        public RoomReservationDtoBuilder reservationDate(LocalDateTime reservationDate) {
            this.reservationDate = reservationDate;
            return this;
        }
        
        public RoomReservationDtoBuilder startTime(LocalDateTime startTime) {
            this.startTime = startTime;
            return this;
        }
        
        public RoomReservationDtoBuilder endTime(LocalDateTime endTime) {
            this.endTime = endTime;
            return this;
        }
        
        public RoomReservationDtoBuilder purpose(String purpose) {
            this.purpose = purpose;
            return this;
        }
        
        public RoomReservationDtoBuilder attendeesCount(Integer attendeesCount) {
            this.attendeesCount = attendeesCount;
            return this;
        }
        
        public RoomReservationDtoBuilder specialRequirements(String specialRequirements) {
            this.specialRequirements = specialRequirements;
            return this;
        }
        
        public RoomReservationDtoBuilder status(String status) {
            this.status = status;
            return this;
        }
        
        public RoomReservationDtoBuilder totalPriceCents(Long totalPriceCents) {
            this.totalPriceCents = totalPriceCents;
            return this;
        }
        
        public RoomReservationDtoBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public RoomReservationDtoBuilder updatedAt(LocalDateTime updatedAt) {
            this.updatedAt = updatedAt;
            return this;
        }
        
        public RoomReservationDtoBuilder notes(String notes) {
            this.notes = notes;
            return this;
        }
        
        public RoomReservationDto build() {
            return new RoomReservationDto(id, roomId, roomName, userId, userName, reservationDate,
                                        startTime, endTime, purpose, attendeesCount, specialRequirements,
                                        status, totalPriceCents, createdAt, updatedAt, notes);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }
    
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public LocalDateTime getReservationDate() { return reservationDate; }
    public void setReservationDate(LocalDateTime reservationDate) { this.reservationDate = reservationDate; }
    
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }
    
    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }
    
    public String getPurpose() { return purpose; }
    public void setPurpose(String purpose) { this.purpose = purpose; }
    
    public Integer getAttendeesCount() { return attendeesCount; }
    public void setAttendeesCount(Integer attendeesCount) { this.attendeesCount = attendeesCount; }
    
    public String getSpecialRequirements() { return specialRequirements; }
    public void setSpecialRequirements(String specialRequirements) { this.specialRequirements = specialRequirements; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Long getTotalPriceCents() { return totalPriceCents; }
    public void setTotalPriceCents(Long totalPriceCents) { this.totalPriceCents = totalPriceCents; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
