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
}
