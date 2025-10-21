package com.vegnbio.api.modules.cart.dto;

import java.time.LocalDateTime;

public class CartItemDto {
    private Long id;
    private Long menuItemId;
    private String menuItemName;
    private String menuItemDescription;
    private Integer quantity;
    private Long unitPriceCents;
    private Long totalPriceCents;
    private String specialInstructions;
    private LocalDateTime addedAt;
    
    public CartItemDto() {}
    
    public CartItemDto(Long id, Long menuItemId, String menuItemName, String menuItemDescription, 
                      Integer quantity, Long unitPriceCents, Long totalPriceCents, 
                      String specialInstructions, LocalDateTime addedAt) {
        this.id = id;
        this.menuItemId = menuItemId;
        this.menuItemName = menuItemName;
        this.menuItemDescription = menuItemDescription;
        this.quantity = quantity;
        this.unitPriceCents = unitPriceCents;
        this.totalPriceCents = totalPriceCents;
        this.specialInstructions = specialInstructions;
        this.addedAt = addedAt;
    }
    
    public static CartItemDtoBuilder builder() {
        return new CartItemDtoBuilder();
    }
    
    public static class CartItemDtoBuilder {
        private Long id;
        private Long menuItemId;
        private String menuItemName;
        private String menuItemDescription;
        private Integer quantity;
        private Long unitPriceCents;
        private Long totalPriceCents;
        private String specialInstructions;
        private LocalDateTime addedAt;
        
        public CartItemDtoBuilder id(Long id) {
            this.id = id;
            return this;
        }
        
        public CartItemDtoBuilder menuItemId(Long menuItemId) {
            this.menuItemId = menuItemId;
            return this;
        }
        
        public CartItemDtoBuilder menuItemName(String menuItemName) {
            this.menuItemName = menuItemName;
            return this;
        }
        
        public CartItemDtoBuilder menuItemDescription(String menuItemDescription) {
            this.menuItemDescription = menuItemDescription;
            return this;
        }
        
        public CartItemDtoBuilder quantity(Integer quantity) {
            this.quantity = quantity;
            return this;
        }
        
        public CartItemDtoBuilder unitPriceCents(Long unitPriceCents) {
            this.unitPriceCents = unitPriceCents;
            return this;
        }
        
        public CartItemDtoBuilder totalPriceCents(Long totalPriceCents) {
            this.totalPriceCents = totalPriceCents;
            return this;
        }
        
        public CartItemDtoBuilder specialInstructions(String specialInstructions) {
            this.specialInstructions = specialInstructions;
            return this;
        }
        
        public CartItemDtoBuilder addedAt(LocalDateTime addedAt) {
            this.addedAt = addedAt;
            return this;
        }
        
        public CartItemDto build() {
            return new CartItemDto(id, menuItemId, menuItemName, menuItemDescription, 
                                 quantity, unitPriceCents, totalPriceCents, specialInstructions, addedAt);
        }
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getMenuItemId() { return menuItemId; }
    public void setMenuItemId(Long menuItemId) { this.menuItemId = menuItemId; }
    
    public String getMenuItemName() { return menuItemName; }
    public void setMenuItemName(String menuItemName) { this.menuItemName = menuItemName; }
    
    public String getMenuItemDescription() { return menuItemDescription; }
    public void setMenuItemDescription(String menuItemDescription) { this.menuItemDescription = menuItemDescription; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    
    public Long getUnitPriceCents() { return unitPriceCents; }
    public void setUnitPriceCents(Long unitPriceCents) { this.unitPriceCents = unitPriceCents; }
    
    public Long getTotalPriceCents() { return totalPriceCents; }
    public void setTotalPriceCents(Long totalPriceCents) { this.totalPriceCents = totalPriceCents; }
    
    public String getSpecialInstructions() { return specialInstructions; }
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; }
    
    public LocalDateTime getAddedAt() { return addedAt; }
    public void setAddedAt(LocalDateTime addedAt) { this.addedAt = addedAt; }
}
