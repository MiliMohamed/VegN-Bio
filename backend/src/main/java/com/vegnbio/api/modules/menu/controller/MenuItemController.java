package com.vegnbio.api.modules.menu.controller;

import com.vegnbio.api.modules.menu.dto.CreateMenuItemRequest;
import com.vegnbio.api.modules.menu.dto.MenuItemDto;
import com.vegnbio.api.modules.menu.service.MenuItemService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/menu-items")
@RequiredArgsConstructor
public class MenuItemController {
    
    private final MenuItemService menuItemService;
    
    @PostMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<MenuItemDto> createMenuItem(@Valid @RequestBody CreateMenuItemRequest request) {
        MenuItemDto menuItem = menuItemService.createMenuItem(request);
        return ResponseEntity.ok(menuItem);
    }
    
    @GetMapping("/menu/{menuId}")
    public ResponseEntity<List<MenuItemDto>> getMenuItemsByMenu(@PathVariable Long menuId) {
        List<MenuItemDto> menuItems = menuItemService.getMenuItemsByMenu(menuId);
        return ResponseEntity.ok(menuItems);
    }
    
    @GetMapping("/search")
    public ResponseEntity<List<MenuItemDto>> searchMenuItems(@RequestParam String name) {
        List<MenuItemDto> menuItems = menuItemService.searchMenuItems(name);
        return ResponseEntity.ok(menuItems);
    }
    
    @GetMapping("/{menuItemId}")
    public ResponseEntity<MenuItemDto> getMenuItem(@PathVariable Long menuItemId) {
        MenuItemDto menuItem = menuItemService.getMenuItemById(menuItemId);
        return ResponseEntity.ok(menuItem);
    }
    
    @PutMapping("/{menuItemId}")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<MenuItemDto> updateMenuItem(@PathVariable Long menuItemId, @Valid @RequestBody CreateMenuItemRequest request) {
        MenuItemDto menuItem = menuItemService.updateMenuItem(menuItemId, request);
        return ResponseEntity.ok(menuItem);
    }
    
    @DeleteMapping("/{menuItemId}")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<Void> deleteMenuItem(@PathVariable Long menuItemId) {
        menuItemService.deleteMenuItem(menuItemId);
        return ResponseEntity.noContent().build();
    }
}
