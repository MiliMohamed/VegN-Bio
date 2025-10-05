package com.vegnbio.api.modules.caisse.entity;

import com.vegnbio.api.modules.menu.entity.MenuItem;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "ticket_lines")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class TicketLine {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ticket_id", nullable = false)
    private Ticket ticket;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_item_id", nullable = false)
    private MenuItem menuItem;
    
    @Column(nullable = false)
    private Integer qty;
    
    @Column(name = "unit_price_cents", nullable = false)
    private Integer unitPriceCents;
    
    @Column(name = "line_total_cents", nullable = false)
    private Integer lineTotalCents;
    
    @PrePersist
    @PreUpdate
    protected void calculateTotal() {
        if (qty != null && unitPriceCents != null) {
            this.lineTotalCents = qty * unitPriceCents;
        }
    }
}
