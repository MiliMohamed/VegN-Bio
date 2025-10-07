package com.vegnbio.restaurant.service;

import com.vegnbio.restaurant.dto.MenuItemDto;
import com.vegnbio.restaurant.entity.MenuItem;
import com.vegnbio.restaurant.repository.MenuItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MenuService {

    private final MenuItemRepository menuItemRepository;

    public List<MenuItemDto> getAllMenuItems() {
        return menuItemRepository.findAll().stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public MenuItemDto getMenuItemById(Long id) {
        MenuItem menuItem = menuItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menu item not found"));
        return convertToDto(menuItem);
    }

    public List<MenuItemDto> searchMenuItems(String query) {
        return menuItemRepository.findByNameContainingIgnoreCaseOrDescriptionContainingIgnoreCase(query, query)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<MenuItemDto> getMenuItemsByCategory(String category) {
        return menuItemRepository.findByCategory(category)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public List<MenuItemDto> filterMenuItems(Boolean isVegan, Boolean isVegetarian, Boolean isGlutenFree, List<String> excludedAllergens) {
        return menuItemRepository.findAll().stream()
                .filter(item -> {
                    if (isVegan != null && isVegan && !item.getIsVegan()) return false;
                    if (isVegetarian != null && isVegetarian && !item.getIsVegetarian()) return false;
                    if (isGlutenFree != null && isGlutenFree && !item.getIsGlutenFree()) return false;
                    if (excludedAllergens != null && !excludedAllergens.isEmpty()) {
                        return item.getAllergens().stream().noneMatch(excludedAllergens::contains);
                    }
                    return true;
                })
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public MenuItemDto createMenuItem(MenuItemDto menuItemDto) {
        MenuItem menuItem = convertToEntity(menuItemDto);
        MenuItem savedItem = menuItemRepository.save(menuItem);
        return convertToDto(savedItem);
    }

    public MenuItemDto updateMenuItem(Long id, MenuItemDto menuItemDto) {
        MenuItem existingItem = menuItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        // Mettre à jour les champs
        existingItem.setName(menuItemDto.name());
        existingItem.setDescription(menuItemDto.description());
        existingItem.setPrice(menuItemDto.price());
        existingItem.setCategory(menuItemDto.category());
        existingItem.setAllergens(menuItemDto.allergens());
        existingItem.setImageUrl(menuItemDto.imageUrl());
        existingItem.setIsVegan(menuItemDto.isVegan());
        existingItem.setIsVegetarian(menuItemDto.isVegetarian());
        existingItem.setIsGlutenFree(menuItemDto.isGlutenFree());
        existingItem.setIngredients(menuItemDto.ingredients());
        existingItem.setCalories(menuItemDto.calories());
        existingItem.setPreparationTime(menuItemDto.preparationTime());
        
        MenuItem updatedItem = menuItemRepository.save(existingItem);
        return convertToDto(updatedItem);
    }

    public void deleteMenuItem(Long id) {
        menuItemRepository.deleteById(id);
    }

    private MenuItemDto convertToDto(MenuItem menuItem) {
        return new MenuItemDto(
                menuItem.getId(),
                menuItem.getName(),
                menuItem.getDescription(),
                menuItem.getPrice(),
                menuItem.getCategory(),
                menuItem.getAllergens(),
                menuItem.getImageUrl(),
                menuItem.getIsVegan(),
                menuItem.getIsVegetarian(),
                menuItem.getIsGlutenFree(),
                menuItem.getIngredients(),
                menuItem.getCalories(),
                menuItem.getPreparationTime()
        );
    }

    private MenuItem convertToEntity(MenuItemDto dto) {
        MenuItem menuItem = new MenuItem();
        menuItem.setName(dto.name());
        menuItem.setDescription(dto.description());
        menuItem.setPrice(dto.price());
        menuItem.setCategory(dto.category());
        menuItem.setAllergens(dto.allergens());
        menuItem.setImageUrl(dto.imageUrl());
        menuItem.setIsVegan(dto.isVegan());
        menuItem.setIsVegetarian(dto.isVegetarian());
        menuItem.setIsGlutenFree(dto.isGlutenFree());
        menuItem.setIngredients(dto.ingredients());
        menuItem.setCalories(dto.calories());
        menuItem.setPreparationTime(dto.preparationTime());
        return menuItem;
    }
}
