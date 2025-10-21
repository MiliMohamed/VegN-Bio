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
}
