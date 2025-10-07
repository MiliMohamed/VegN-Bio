package com.vegnbio.restaurant.dto;

import java.util.List;

public record MenuItemDto(
    Long id,
    String name,
    String description,
    Double price,
    String category,
    List<String> allergens,
    String imageUrl,
    Boolean isVegan,
    Boolean isVegetarian,
    Boolean isGlutenFree,
    List<String> ingredients,
    Integer calories,
    String preparationTime
) {}
