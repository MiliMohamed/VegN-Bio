package com.vegnbio.api.modules.cart.repository;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.cart.entity.Cart;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    
    @Query("SELECT c FROM Cart c LEFT JOIN FETCH c.items ci LEFT JOIN FETCH ci.menuItem WHERE c.user = :user AND c.status = 'ACTIVE'")
    Optional<Cart> findActiveCartByUser(@Param("user") User user);
    
    @Query("SELECT c FROM Cart c WHERE c.user = :user AND c.status = 'ACTIVE'")
    Optional<Cart> findActiveCartByUserSimple(@Param("user") User user);
    
    @Query("SELECT COUNT(c) FROM Cart c WHERE c.user = :user AND c.status = 'ACTIVE'")
    long countActiveCartsByUser(@Param("user") User user);
}
