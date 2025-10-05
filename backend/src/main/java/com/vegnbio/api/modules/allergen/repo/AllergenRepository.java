package com.vegnbio.api.modules.allergen.repo;

import com.vegnbio.api.modules.allergen.entity.Allergen;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AllergenRepository extends JpaRepository<Allergen, Long> {
    
    Optional<Allergen> findByCode(String code);
}
