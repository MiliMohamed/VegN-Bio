package com.vegnbio.api.modules.cart.entity;

import com.vegnbio.api.modules.menu.entity.MenuItem;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "cart_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class CartItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cart_id", nullable = false)
    private Cart cart;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;
    
    @Column(nullable = false)
    private Integer quantity;
    
    @Column(name = "unit_price_cents", nullable = false)
    private Long unitPriceCents;
    
    @Column(nullable = false)
    @Builder.Default
    private java.time.LocalDateTime addedAt = java.time.LocalDateTime.now();
    
    @Column
    private String specialInstructions;
    
    public long getTotalPriceCents() {
        return quantity * unitPriceCents;
    }
    
    // Getters manuels pour éviter les problèmes de compilation
    public Long getId() { return id; }
    public Cart getCart() { return cart; }
    public MenuItem getMenuItem() { return menuItem; }
    public Integer getQuantity() { return quantity; }
    public Long getUnitPriceCents() { return unitPriceCents; }
    public java.time.LocalDateTime getAddedAt() { return addedAt; }
    public String getSpecialInstructions() { return specialInstructions; }
    
    // Setters manuels
    public void setId(Long id) { this.id = id; }
    public void setCart(Cart cart) { this.cart = cart; }
    public void setMenuItem(MenuItem menuItem) { this.menuItem = menuItem; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public void setUnitPriceCents(Long unitPriceCents) { this.unitPriceCents = unitPriceCents; }
    public void setAddedAt(java.time.LocalDateTime addedAt) { this.addedAt = addedAt; }
    public void setSpecialInstructions(String specialInstructions) { this.specialInstructions = specialInstructions; }
}
