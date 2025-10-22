package com.vegnbio.api.modules.menu.controller;

import com.vegnbio.api.modules.menu.dto.MenuDto;
import com.vegnbio.api.modules.menu.dto.MenuItemDto;
import com.vegnbio.api.modules.menu.service.MenuService;
import com.vegnbio.api.modules.menu.service.MenuItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/public")
@RequiredArgsConstructor
public class PublicMenuController {
    
    private final MenuService menuService;
    private final MenuItemService menuItemService;
    
    /**
     * Endpoint public pour récupérer tous les menus disponibles
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menus")
    public ResponseEntity<List<MenuDto>> getAllMenus() {
        try {
            List<MenuDto> menus = menuService.getAllMenus();
            return ResponseEntity.ok(menus);
        } catch (Exception e) {
            System.err.println("Error fetching all menus: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour récupérer les menus d'un restaurant par son code
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menus/restaurant/{restaurantCode}")
    public ResponseEntity<List<MenuDto>> getMenusByRestaurantCode(@PathVariable String restaurantCode) {
        try {
            List<MenuDto> menus = menuService.getMenusByRestaurantCode(restaurantCode);
            return ResponseEntity.ok(menus);
        } catch (Exception e) {
            System.err.println("Error fetching menus for restaurant " + restaurantCode + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour récupérer tous les plats disponibles
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menu-items")
    public ResponseEntity<List<MenuItemDto>> getAllMenuItems() {
        try {
            List<MenuItemDto> menuItems = menuItemService.getAllMenuItems();
            return ResponseEntity.ok(menuItems);
        } catch (Exception e) {
            System.err.println("Error fetching all menu items: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour récupérer les plats d'un menu
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menu-items/menu/{menuId}")
    public ResponseEntity<List<MenuItemDto>> getMenuItemsByMenu(@PathVariable Long menuId) {
        try {
            List<MenuItemDto> menuItems = menuItemService.getMenuItemsByMenu(menuId);
            return ResponseEntity.ok(menuItems);
        } catch (Exception e) {
            System.err.println("Error fetching menu items for menu " + menuId + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour rechercher des plats par nom
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menu-items/search")
    public ResponseEntity<List<MenuItemDto>> searchMenuItems(@RequestParam String name) {
        try {
            List<MenuItemDto> menuItems = menuItemService.searchMenuItems(name);
            return ResponseEntity.ok(menuItems);
        } catch (Exception e) {
            System.err.println("Error searching menu items: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour récupérer les plats d'un restaurant par son code
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menu-items/restaurant/{restaurantCode}")
    public ResponseEntity<List<MenuItemDto>> getMenuItemsByRestaurantCode(@PathVariable String restaurantCode) {
        try {
            List<MenuItemDto> menuItems = menuItemService.getMenuItemsByRestaurantCode(restaurantCode);
            return ResponseEntity.ok(menuItems);
        } catch (Exception e) {
            System.err.println("Error fetching menu items for restaurant " + restaurantCode + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.ok(List.of());
        }
    }
    
    /**
     * Endpoint public pour récupérer un menu par son ID
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menus/{menuId}")
    public ResponseEntity<MenuDto> getMenuById(@PathVariable Long menuId) {
        try {
            MenuDto menu = menuService.getMenuById(menuId);
            return ResponseEntity.ok(menu);
        } catch (Exception e) {
            System.err.println("Error fetching menu " + menuId + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Endpoint public pour récupérer un plat par son ID
     * Accessible sans authentification pour les clients
     */
    @GetMapping("/menu-items/{menuItemId}")
    public ResponseEntity<MenuItemDto> getMenuItemById(@PathVariable Long menuItemId) {
        try {
            MenuItemDto menuItem = menuItemService.getMenuItemById(menuItemId);
            return ResponseEntity.ok(menuItem);
        } catch (Exception e) {
            System.err.println("Error fetching menu item " + menuItemId + ": " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.notFound().build();
        }
    }
}
