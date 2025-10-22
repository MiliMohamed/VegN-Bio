package com.vegnbio.api.modules.menu.service;

import com.vegnbio.api.modules.menu.dto.CreateMenuRequest;
import com.vegnbio.api.modules.menu.dto.MenuDto;
import com.vegnbio.api.modules.menu.entity.Menu;
import com.vegnbio.api.modules.menu.repo.MenuRepository;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class MenuService {
    
    private final MenuRepository menuRepository;
    private final RestaurantRepository restaurantRepository;
    
    public MenuDto createMenu(CreateMenuRequest request) {
        Restaurant restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        Menu menu = Menu.builder()
                .restaurant(restaurant)
                .title(request.title())
                .activeFrom(request.activeFrom())
                .activeTo(request.activeTo())
                .build();
        
        Menu savedMenu = menuRepository.save(menu);
        return mapToDto(savedMenu);
    }
    
    @Transactional(readOnly = true)
    public List<MenuDto> getAllMenus() {
        try {
            List<Menu> menus = menuRepository.findAll();
            return menus.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching all menus: " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuDto> getMenusByRestaurant(Long restaurantId) {
        try {
            Restaurant restaurant = restaurantRepository.findById(restaurantId)
                    .orElseThrow(() -> new RuntimeException("Restaurant not found with ID: " + restaurantId));
            
            List<Menu> menus = menuRepository.findByRestaurant(restaurant);
            System.out.println("Found " + menus.size() + " menus for restaurant " + restaurantId);
            
            return menus.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            System.err.println("Error fetching menus for restaurant " + restaurantId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error fetching menus for restaurant " + restaurantId + ": " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuDto> getMenusByRestaurantCode(String restaurantCode) {
        try {
            Restaurant restaurant = restaurantRepository.findByCode(restaurantCode)
                    .orElseThrow(() -> new RuntimeException("Restaurant not found with code: " + restaurantCode));
            
            List<Menu> menus = menuRepository.findByRestaurant(restaurant);
            return menus.stream()
                    .map(this::mapToDto)
                    .toList();
        } catch (Exception e) {
            throw new RuntimeException("Error fetching menus for restaurant " + restaurantCode + ": " + e.getMessage(), e);
        }
    }
    
    @Transactional(readOnly = true)
    public List<MenuDto> getMenusByRestaurantAndDate(Long restaurantId, LocalDate date) {
        Restaurant restaurant = restaurantRepository.findById(restaurantId)
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        return menuRepository.findByRestaurantAndDate(restaurant, date)
                .stream()
                .map(this::mapToDto)
                .toList();
    }
    
    @Transactional(readOnly = true)
    public MenuDto getMenuById(Long menuId) {
        Menu menu = menuRepository.findById(menuId)
                .orElseThrow(() -> new RuntimeException("Menu not found"));
        return mapToDto(menu);
    }
    
    @Transactional
    public MenuDto updateMenu(Long menuId, CreateMenuRequest request) {
        Menu menu = menuRepository.findById(menuId)
                .orElseThrow(() -> new RuntimeException("Menu not found"));
        
        Restaurant restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        menu.setTitle(request.title());
        menu.setActiveFrom(request.activeFrom());
        menu.setActiveTo(request.activeTo());
        menu.setRestaurant(restaurant);
        
        Menu savedMenu = menuRepository.save(menu);
        return mapToDto(savedMenu);
    }
    
    @Transactional
    public void deleteMenu(Long menuId) {
        if (!menuRepository.existsById(menuId)) {
            throw new RuntimeException("Menu not found");
        }
        menuRepository.deleteById(menuId);
    }
    
    private MenuDto mapToDto(Menu menu) {
        return new MenuDto(
                menu.getId(),
                menu.getTitle(),
                menu.getActiveFrom(),
                menu.getActiveTo(),
                menu.getMenuItems() != null ? 
                    menu.getMenuItems().stream()
                        .map(this::mapMenuItemToDto)
                        .toList() : List.of()
        );
    }
    
    private com.vegnbio.api.modules.menu.dto.MenuItemDto mapMenuItemToDto(com.vegnbio.api.modules.menu.entity.MenuItem menuItem) {
        return new com.vegnbio.api.modules.menu.dto.MenuItemDto(
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
