package com.vegnbio.api.modules.cart.controller;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.cart.dto.*;
import com.vegnbio.api.modules.cart.service.CartService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/cart")
@RequiredArgsConstructor
@Tag(name = "Cart", description = "Gestion du panier d'achat")
public class CartController {
    
    private final CartService cartService;
    
    @GetMapping
    @Operation(summary = "Récupérer le panier actif de l'utilisateur")
    public ResponseEntity<CartDto> getCart(@AuthenticationPrincipal User user) {
        CartDto cart = cartService.getActiveCart(user);
        return ResponseEntity.ok(cart);
    }
    
    @PostMapping("/items")
    @Operation(summary = "Ajouter un article au panier")
    public ResponseEntity<CartDto> addToCart(
            @AuthenticationPrincipal User user,
            @RequestBody AddToCartRequest request) {
        CartDto cart = cartService.addToCart(user, request);
        return ResponseEntity.ok(cart);
    }
    
    @PutMapping("/items/{cartItemId}")
    @Operation(summary = "Modifier un article du panier")
    public ResponseEntity<CartDto> updateCartItem(
            @AuthenticationPrincipal User user,
            @PathVariable Long cartItemId,
            @RequestBody UpdateCartItemRequest request) {
        CartDto cart = cartService.updateCartItem(user, cartItemId, request);
        return ResponseEntity.ok(cart);
    }
    
    @DeleteMapping("/items/{cartItemId}")
    @Operation(summary = "Supprimer un article du panier")
    public ResponseEntity<CartDto> removeFromCart(
            @AuthenticationPrincipal User user,
            @PathVariable Long cartItemId) {
        CartDto cart = cartService.removeFromCart(user, cartItemId);
        return ResponseEntity.ok(cart);
    }
    
    @DeleteMapping
    @Operation(summary = "Vider le panier")
    public ResponseEntity<Void> clearCart(@AuthenticationPrincipal User user) {
        cartService.clearCart(user);
        return ResponseEntity.noContent().build();
    }
    
    @PostMapping("/abandon")
    @Operation(summary = "Abandonner le panier")
    public ResponseEntity<Void> abandonCart(@AuthenticationPrincipal User user) {
        cartService.abandonCart(user);
        return ResponseEntity.noContent().build();
    }
}
