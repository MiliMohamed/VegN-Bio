package com.vegnbio.api.modules.allergen.service;

import com.vegnbio.api.modules.allergen.dto.AllergenDto;
import com.vegnbio.api.modules.allergen.entity.Allergen;
import com.vegnbio.api.modules.allergen.repo.AllergenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AllergenService {
    
    private final AllergenRepository allergenRepository;
    
    public List<AllergenDto> getAllAllergens() {
        return allergenRepository.findAll()
                .stream()
                .map(this::mapToDto)
                .toList();
    }
    
    public AllergenDto getAllergenByCode(String code) {
        return allergenRepository.findByCode(code)
                .map(this::mapToDto)
                .orElseThrow(() -> new RuntimeException("Allergen not found"));
    }
    
    private AllergenDto mapToDto(Allergen allergen) {
        return new AllergenDto(
                allergen.getId(),
                allergen.getCode(),
                allergen.getLabel()
        );
    }
}
