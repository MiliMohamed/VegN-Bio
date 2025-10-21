package com.vegnbio.api.modules.cart.dto;

public class AddToCartRequest {
    private Long menuItemId;
    private Integer quantity;
    private String specialInstructions;
    
    public AddToCartRequest() {}
    
    public AddToCartRequest(Long menuItemId, Integer quantity, String specialInstructions) {
        this.menuItemId = menuItemId;
        this.quantity = quantity;
        this.specialInstructions = specialInstructions;
    }
    
    public static AddToCartRequestBuilder builder() {
        return new AddToCartRequestBuilder();
    }
    
    public static class AddToCartRequestBuilder {
        private Long menuItemId;
        private Integer quantity;
        private String specialInstructions;
        
        public AddToCartRequestBuilder menuItemIdCh(Long menuItemId) {
            this.menuItemId = menuItemId;
            return this;
        }
        
        public AddToCartRequestBuilder quantity(Integer quantity) {
            this.quantity = quantity;
            return this;
        }
        
        public AddToCartRequestBuilder specialInstructions(String specialInstructions) {
            this.specialInstructions = specialInstructions;
            return this;
        }
        
        public AddToCartRequest build() {
            return new AddToCartRequest(menuItemId, quantity, specialInstructions);
        }
    }
    
    // Getters and Setters
    public Long getMenuItemId() { return menuItemId; }
    public void setMenuItemId(Long menuItemId) { this.menuItemId = menuItemId; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    
    public String getSpecialInstructions() { return specialInstructions; }
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; }
}
