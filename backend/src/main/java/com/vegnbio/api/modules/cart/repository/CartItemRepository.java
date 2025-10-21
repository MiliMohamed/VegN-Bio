package com.vegnbio.api.modules.cart.repository;

import com.vegnbio.api.modules.cart.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    
    @Query("SELECT ci FROM CartItem ci WHERE ci.cart.id = :cartId")
    List<CartItem> findByCartId(@Param("cartId") Long cartId);
    
    @Query("SELECT ci FROM CartItem ci WHERE ci.cart.id = :cartId AND ci.menuItem.id = :menuItemId")
    Optional<CartItem> findByCartIdAndMenuItemId(@Param("cartId") Long cartId, @Param("menuItemId") Long menuItemId);
    
    void deleteByCartId(Long cartId);
}
