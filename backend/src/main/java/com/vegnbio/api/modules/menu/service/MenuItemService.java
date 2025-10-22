package com.vegnbio.api.modules.menu.service;

import com.vegnbio.api.modules.allergen.entity.Allergen;
import com.vegnbio.api.modules.allergen.repo.AllergenRepository;
import com.vegnbio.api.modules.menu.dto.CreateMenuItemRequest;
import com.vegnbio.api.modules.menu.dto.MenuItemDto;
import com.vegnbio.api.modules.menu.entity.Menu;
import com.vegnbio.api.modules.menu.entity.MenuItem;
import com.vegnbio.api.modules.menu.repo.MenuItemRepository;
import com.vegnbio.api.modules.menu.repo.MenuRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class MenuItemService {
    
    private final MenuItemRepository menuItemRepository;
    private final MenuRepository menuRepository;
    private final AllergenRepository allergenRepository;
    
    public MenuItemDto createMenuItem(CreateMenuItemRequest request) {
        Menu menu = menuRepository.findById(request.menuId())
                .orElseThrow(() -> new RuntimeException("Menu not found"));
        
        List<Allergen> allergens = List.of();
        if (request.allergenIds() != null && !request.allergenIds().isEmpty()) {
            allergens = allergenRepository.findAllById(request.allergenIds());
        }
        
        MenuItem menuItem = MenuItem.builder()
                .menu(menu)
                .name(request.name())
                .description(request.description())
                .priceCents(request.priceCents())
                .isVegan(request.isVegan())
                .allergens(allergens)
                .build();
        
        MenuItem savedMenuItem = menuItemRepository.save(menuItem);
        return mapToDto(savedMenuItem);
    }
    
    @Transactional(readOnly = true)
    public List<MenuItemDto> getAllMenuItems() {
        try {
            List<MenuItem> menuItems = menuItemRepository.findAll();
            return menuItems.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching all menu items: " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuItemDto> getMenuItemsByMenu(Long menuId) {
        try {
            List<MenuItem> menuItems = menuItemRepository.findByMenuId(menuId);
            return menuItems.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching menu items for menu " + menuId + ": " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuItemDto> getMenuItemsByRestaurantCode(String restaurantCode) {
        try {
            List<MenuItem> menuItems = menuItemRepository.findByRestaurantCode(restaurantCode);
            return menuItems.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching menu items for restaurant " + restaurantCode + ": " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuItemDto> searchMenuItems(String name) {
        return menuItemRepository.findByNameContainingIgnoreCase(name)
                .stream()
                .map(this::mapToDto)
                .toList();
    }
    
    @Transactional(readOnly = true)
    public MenuItemDto getMenuItemById(Long menuItemId) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
                .orElseThrow(() -> new RuntimeException("MenuItem not found"));
        return mapToDto(menuItem);
    }
    
    @Transactional
    public MenuItemDto updateMenuItem(Long menuItemId, CreateMenuItemRequest request) {
        MenuItem menuItem = menuItemRepository.findById(menuItemId)
                .orElseThrow(() -> new RuntimeException("MenuItem not found"));
        
        Menu menu = menuRepository.findById(request.menuId())
                .orElseThrow(() -> new RuntimeException("Menu not found"));
        
        menuItem.setName(request.name());
        menuItem.setDescription(request.description());
        menuItem.setPriceCents(request.priceCents());
        menuItem.setIsVegan(request.isVegan());
        menuItem.setMenu(menu);
        
        // Gérer les allergènes si nécessaire
        if (request.allergenIds() != null && !request.allergenIds().isEmpty()) {
            List<Allergen> allergens = allergenRepository.findAllById(request.allergenIds());
            menuItem.setAllergens(allergens);
        }
        
        MenuItem savedMenuItem = menuItemRepository.save(menuItem);
        return mapToDto(savedMenuItem);
    }
    
    @Transactional
    public void deleteMenuItem(Long menuItemId) {
        if (!menuItemRepository.existsById(menuItemId)) {
            throw new RuntimeException("MenuItem not found");
        }
        menuItemRepository.deleteById(menuItemId);
    }
    
    @Transactional(readOnly = true)
    public List<MenuItemDto> filterMenuItems(String name, Boolean isVegan, Integer minPrice, Integer maxPrice, List<Long> excludeAllergenIds) {
        List<MenuItem> allItems = menuItemRepository.findAll();
        
        return allItems.stream()
                .filter(item -> {
                    // Filtre par nom
                    if (name != null && !name.trim().isEmpty()) {
                        if (!item.getName().toLowerCase().contains(name.toLowerCase()) &&
                            !item.getDescription().toLowerCase().contains(name.toLowerCase())) {
                            return false;
                        }
                    }
                    
                    // Filtre par végétalien
                    if (isVegan != null && item.getIsVegan() != isVegan) {
                        return false;
                    }
                    
                    // Filtre par prix
                    if (minPrice != null && item.getPriceCents() < minPrice) {
                        return false;
                    }
                    if (maxPrice != null && item.getPriceCents() > maxPrice) {
                        return false;
                    }
                    
                    // Filtre par allergènes (exclure les items contenant les allergènes spécifiés)
                    if (excludeAllergenIds != null && !excludeAllergenIds.isEmpty()) {
                        if (item.getAllergens() != null) {
                            boolean hasExcludedAllergen = item.getAllergens().stream()
                                    .anyMatch(allergen -> excludeAllergenIds.contains(allergen.getId()));
                            if (hasExcludedAllergen) {
                                return false;
                            }
                        }
                    }
                    
                    return true;
                })
                .map(this::mapToDto)
                .toList();
    }
    
    private MenuItemDto mapToDto(MenuItem menuItem) {
        return new MenuItemDto(
                menuItem.getId(),
                menuItem.getName(),
                menuItem.getDescription(),
                menuItem.getPriceCents(),
                menuItem.getIsVegan(),
                menuItem.getAllergens() != null ?
                    menuItem.getAllergens().stream()
                        .map(allergen -> new com.vegnbio.api.modules.allergen.dto.AllergenDto(
                                allergen.getId(),
                                allergen.getCode(),
                                allergen.getLabel()
                        ))
                        .toList() : List.of()
        );
    }
}
