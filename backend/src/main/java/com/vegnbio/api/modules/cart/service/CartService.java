package com.vegnbio.api.modules.cart.service;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.cart.dto.*;
import com.vegnbio.api.modules.cart.entity.Cart;
import com.vegnbio.api.modules.cart.entity.CartItem;
import com.vegnbio.api.modules.cart.repository.CartItemRepository;
import com.vegnbio.api.modules.cart.repository.CartRepository;
import com.vegnbio.api.modules.menu.entity.MenuItem;
import com.vegnbio.api.modules.menu.repo.MenuItemRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class CartService {
    
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final MenuItemRepository menuItemRepository;
    
    public CartDto getActiveCart(User user) {
        Cart cart = cartRepository.findActiveCartByUser(user)
                .orElseGet(() -> createNewCart(user));
        
        return convertToDto(cart);
    }
    
    public CartDto addToCart(User user, AddToCartRequest request) {
        MenuItem menuItem = menuItemRepository.findById(request.getMenuItemId())
                .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        Cart cart = cartRepository.findActiveCartByUserSimple(user)
                .orElseGet(() -> createNewCart(user));
        
        Optional<CartItem> existingItem = cartItemRepository.findByCartIdAndMenuItemId(
                cart.getId(), request.getMenuItemId());
        
        if (existingItem.isPresent()) {
            CartItem item = existingItem.get();
            item.setQuantity(item.getQuantity() + request.getQuantity());
            item.setSpecialInstructions(request.getSpecialInstructions());
            cartItemRepository.save(item);
        } else {
            CartItem newItem = CartItem.builder()
                    .cart(cart)
                    .menuItem(menuItem)
                    .quantity(request.getQuantity())
                    .unitPriceCents(menuItem.getPriceCents().longValue())
                    .specialInstructions(request.getSpecialInstructions())
                    .build();
            
            cart.addItem(newItem);
            cartItemRepository.save(newItem);
        }
        
        cartRepository.save(cart);
        return convertToDto(cart);
    }
    
    public CartDto updateCartItem(User user, Long cartItemId, UpdateCartItemRequest request) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        // Vérifier que l'utilisateur est propriétaire du panier
        if (!cartItem.getCart().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized access to cart item");
        }
        
        cartItem.setQuantity(request.getQuantity());
        cartItem.setSpecialInstructions(request.getSpecialInstructions());
        cartItemRepository.save(cartItem);
        
        Cart cart = cartItem.getCart();
        cartRepository.save(cart);
        
        return convertToDto(cart);
    }
    
    public CartDto removeFromCart(User user, Long cartItemId) {
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new RuntimeException("Cart item not found"));
        
        // Vérifier que l'utilisateur est propriétaire du panier
        if (!cartItem.getCart().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Unauthorized access to cart item");
        }
        
        Cart cart = cartItem.getCart();
        cart.removeItem(cartItem);
        cartItemRepository.delete(cartItem);
        cartRepository.save(cart);
        
        return convertToDto(cart);
    }
    
    public void clearCart(User user) {
        Cart cart = cartRepository.findActiveCartByUserSimple(user)
                .orElseThrow(() -> new RuntimeException("No active cart found"));
        
        cartItemRepository.deleteByCartId(cart.getId());
        cart.getItems().clear();
        cartRepository.save(cart);
    }
    
    public void abandonCart(User user) {
        Cart cart = cartRepository.findActiveCartByUserSimple(user)
                .orElseThrow(() -> new RuntimeException("No active cart found"));
        
        cart.setStatus(Cart.CartStatus.ABANDONED);
        cartRepository.save(cart);
    }
    
    private Cart createNewCart(User user) {
        Cart cart = Cart.builder()
                .user(user)
                .status(Cart.CartStatus.ACTIVE)
                .build();
        
        return cartRepository.save(cart);
    }
    
    private CartDto convertToDto(Cart cart) {
        List<CartItemDto> itemDtos = cart.getItems().stream()
                .map(this::convertItemToDto)
                .collect(Collectors.toList());
        
        return CartDto.builder()
                .id(cart.getId())
                .userId(cart.getUser().getId())
                .items(itemDtos)
                .totalItems(cart.getTotalItems())
                .totalPriceCents(cart.getTotalPriceCents())
                .createdAt(cart.getCreatedAt())
                .updatedAt(cart.getUpdatedAt())
                .status(cart.getStatus().name())
                .build();
    }
    
    private CartItemDto convertItemToDto(CartItem item) {
        return CartItemDto.builder()
                .id(item.getId())
                .menuItemId(item.getMenuItem().getId())
                .menuItemName(item.getMenuItem().getName())
                .menuItemDescription(item.getMenuItem().getDescription())
                .quantity(item.getQuantity())
                .unitPriceCents(item.getUnitPriceCents())
                .totalPriceCents(item.getTotalPriceCents())
                .specialInstructions(item.getSpecialInstructions())
                .addedAt(item.getAddedAt())
                .build();
    }
}
