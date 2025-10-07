package com.vegnbio.restaurant.controller;

import com.vegnbio.restaurant.dto.MenuItemDto;
import com.vegnbio.restaurant.service.MenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/menus")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // Pour permettre les requêtes depuis Flutter
public class MenuController {

    private final MenuService menuService;

    /**
     * Récupère tous les plats du menu
     */
    @GetMapping
    public ResponseEntity<List<MenuItemDto>> getAllMenuItems() {
        return ResponseEntity.ok(menuService.getAllMenuItems());
    }

    /**
     * Récupère un plat par son ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<MenuItemDto> getMenuItemById(@PathVariable Long id) {
        return ResponseEntity.ok(menuService.getMenuItemById(id));
    }

    /**
     * Recherche des plats par nom ou description
     */
    @GetMapping("/search")
    public ResponseEntity<List<MenuItemDto>> searchMenuItems(@RequestParam String query) {
        return ResponseEntity.ok(menuService.searchMenuItems(query));
    }

    /**
     * Filtre les plats par catégorie
     */
    @GetMapping("/category/{category}")
    public ResponseEntity<List<MenuItemDto>> getMenuItemsByCategory(@PathVariable String category) {
        return ResponseEntity.ok(menuService.getMenuItemsByCategory(category));
    }

    /**
     * Filtre les plats par régime alimentaire
     */
    @GetMapping("/filter")
    public ResponseEntity<List<MenuItemDto>> filterMenuItems(
            @RequestParam(required = false) Boolean isVegan,
            @RequestParam(required = false) Boolean isVegetarian,
            @RequestParam(required = false) Boolean isGlutenFree,
            @RequestParam(required = false) List<String> excludedAllergens) {
        return ResponseEntity.ok(menuService.filterMenuItems(isVegan, isVegetarian, isGlutenFree, excludedAllergens));
    }

    /**
     * Crée un nouveau plat (ADMIN seulement)
     */
    @PostMapping
    public ResponseEntity<MenuItemDto> createMenuItem(@RequestBody MenuItemDto menuItemDto) {
        return ResponseEntity.ok(menuService.createMenuItem(menuItemDto));
    }

    /**
     * Met à jour un plat existant (ADMIN seulement)
     */
    @PutMapping("/{id}")
    public ResponseEntity<MenuItemDto> updateMenuItem(@PathVariable Long id, @RequestBody MenuItemDto menuItemDto) {
        return ResponseEntity.ok(menuService.updateMenuItem(id, menuItemDto));
    }

    /**
     * Supprime un plat (ADMIN seulement)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMenuItem(@PathVariable Long id) {
        menuService.deleteMenuItem(id);
        return ResponseEntity.noContent().build();
    }
}
