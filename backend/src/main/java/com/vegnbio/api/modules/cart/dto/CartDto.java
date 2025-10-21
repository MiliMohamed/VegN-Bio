package com.vegnbio.api.modules.cart.dto;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartDto {
    private Long id;
    private Long userId;
    private List<CartItemDto> items;
    private int totalItems;
    private long totalPriceCents;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String status;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDto {
    private Long id;
    private Long menuItemId;
    private String menuItemName;
    private String menuItemDescription;
    private Integer quantity;
    private Long unitPriceCents;
    private Long totalPriceCents;
    private String specialInstructions;
    private LocalDateTime addedAt;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddToCartRequest {
    private Long menuItemId;
    private Integer quantity;
    private String specialInstructions;
}

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateCartItemRequest {
    private Integer quantity;
    private String specialInstructions;
}
