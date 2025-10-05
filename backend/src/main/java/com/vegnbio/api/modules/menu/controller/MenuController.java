package com.vegnbio.api.modules.menu.controller;

import com.vegnbio.api.modules.menu.dto.CreateMenuRequest;
import com.vegnbio.api.modules.menu.dto.MenuDto;
import com.vegnbio.api.modules.menu.service.MenuService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/menus")
@RequiredArgsConstructor
public class MenuController {
    
    private final MenuService menuService;
    
    @PostMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<MenuDto> createMenu(@Valid @RequestBody CreateMenuRequest request) {
        MenuDto menu = menuService.createMenu(request);
        return ResponseEntity.ok(menu);
    }
    
    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<MenuDto>> getMenusByRestaurant(@PathVariable Long restaurantId) {
        List<MenuDto> menus = menuService.getMenusByRestaurant(restaurantId);
        return ResponseEntity.ok(menus);
    }
    
    @GetMapping("/restaurant/{restaurantId}/active")
    public ResponseEntity<List<MenuDto>> getActiveMenusByRestaurant(
            @PathVariable Long restaurantId,
            @RequestParam(required = false) LocalDate date) {
        List<MenuDto> menus = menuService.getMenusByRestaurantAndDate(restaurantId, date);
        return ResponseEntity.ok(menus);
    }
}
