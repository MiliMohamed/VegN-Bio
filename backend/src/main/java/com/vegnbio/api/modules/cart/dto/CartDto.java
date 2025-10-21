package com.vegnbio.api.modules.cart.dto;

import java.time.LocalDateTime;
import java.util.List;

public class CartDto {
    private Long id;
    private Long userId;
    private List<CartItemDto> items;
    private int totalItems;
    private long totalPriceCents;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String status;
    
    public CartDto() {}
    
    public CartDto(Long id, Long userId, List<CartItemDto> items, int totalItems, 
                   long totalPriceCents, LocalDateTime createdAt, LocalDateTime updatedAt, String status) {
        this.id = id;
        this.userId = userId;
        this.items = items;
        this.totalItems = totalItems;
        this.totalPriceCents = totalPriceCents;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
    }
    
    public static CartDtoBuilder builder() {
        return new CartDtoBuilder();
    }
    
    public static class CartDtoBuilder {
        private Long id;
        private Long userId;
        private List<CartItemDto> items;
        private int totalItems;
        private long totalPriceCents;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private String status;
        
        public CartDtoBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public CartDtoBuilder userId(Long userId) {
            this.userId = userId;
            return this;
        }
        
        public CartDtoBuilder items(List<CartItemDto> items) {
            this.items = items;
            return this;
        }
        
        public CartDtoBuilder totalItems(int totalItems) {
            this.totalItems = totalItems;
            return this;
        }
        
        public CartDtoBuilder totalPriceCents(long totalPriceCents) {
            this.totalPriceCents = totalPriceCents;
            return this;
        }
        
        public CartDtoBuilder createdAt(LocalDateTime createdAt) {
            this.createdAt = createdAt;
            return this;
        }
        
        public CartDtoBuilder updatedAt(LocalDateTime updatedAt) {
            this.updatedAt = updatedAt;
            return this;
        }
        
        public CartDtoBuilder status(String status) {
            this.status = status;
            return this;
        }
        
        public CartDto build() {
            return new CartDto(id, userId, items, totalItems, totalPriceCents, createdAt, updatedAt, status);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    
    public List<CartItemDto> getItems() { return items; }
    public void setItems(List<CartItemDto> items) { this.items = items; }
    
    public int getTotalItems() { return totalItems; }
    public void setTotalItems(int totalItems) { this.totalItems = totalItems; }
    
    public long getTotalPriceCents() { return totalPriceCents; }
    public void setTotalPriceCents(long totalPriceCents) { this.totalPriceCents = totalPriceCents; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
