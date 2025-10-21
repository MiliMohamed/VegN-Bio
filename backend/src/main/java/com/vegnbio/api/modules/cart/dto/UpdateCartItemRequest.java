package com.vegnbio.api.modules.cart.dto;

public class UpdateCartItemRequest {
    private Integer quantity;
    private String specialInstructions;
    
    public UpdateCartItemRequest() {}
    
    public UpdateCartItemRequest(Integer quantity, String specialInstructions) {
        this.quantity = quantity;
        this.specialInstructions = specialInstructions;
    }
    
    public static UpdateCartItemRequestBuilder builder() {
        return new UpdateCartItemRequestBuilder();
    }
    
    public static class UpdateCartItemRequestBuilder {
        private Integer quantity;
        private String specialInstructions;
        
        public UpdateCartItemRequestBuilder quantity(Integer quantity) {
            this.quantity = quantity;
            return this;
        }
        
        public UpdateCartItemRequestBuilder specialInstructions(String specialInstructions) {
            this.specialInstructions = specialInstructions;
            return this;
        }
        
        public UpdateCartItemRequest build() {
            return new UpdateCartItemRequest(quantity, specialInstructions);
        }
    }
    
    // Getters and Setters
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    
    public String getSpecialInstructions() { return specialInstructions; }
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; }
}
