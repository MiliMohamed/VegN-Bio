package com.vegnbio.api.modules.allergen.controller;

import com.vegnbio.api.modules.allergen.dto.AllergenDto;
import com.vegnbio.api.modules.allergen.service.AllergenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/allergens")
@RequiredArgsConstructor
public class AllergenController {
    
    private final AllergenService allergenService;
    
    @GetMapping
    public ResponseEntity<List<AllergenDto>> getAllAllergens() {
        List<AllergenDto> allergens = allergenService.getAllAllergens();
        return ResponseEntity.ok(allergens);
    }
    
    @GetMapping("/{code}")
    public ResponseEntity<AllergenDto> getAllergenByCode(@PathVariable String code) {
        AllergenDto allergen = allergenService.getAllergenByCode(code);
        return ResponseEntity.ok(allergen);
    }
}
