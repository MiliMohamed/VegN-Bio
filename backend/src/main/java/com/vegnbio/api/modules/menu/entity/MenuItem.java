package com.vegnbio.api.modules.menu.entity;

import com.vegnbio.api.modules.allergen.entity.Allergen;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "menu_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EqualsAndHashCode
public class MenuItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_id", nullable = false)
    private Menu menu;
    
    @Column(nullable = false)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "price_cents", nullable = false)
    private Integer priceCents;
    
    @Column(name = "is_vegan", nullable = false)
    @Builder.Default
    private Boolean isVegan = false;
    
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "menu_item_allergens",
        joinColumns = @JoinColumn(name = "menu_item_id"),
        inverseJoinColumns = @JoinColumn(name = "allergen_id")
    )
    private List<Allergen> allergens;
}
