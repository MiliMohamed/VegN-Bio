package com.vegnbio.api.modules.marketplace.repo;

import com.vegnbio.api.modules.marketplace.entity.Supplier;
import com.vegnbio.api.modules.marketplace.entity.SupplierStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SupplierRepository extends JpaRepository<Supplier, Long> {
    
    List<Supplier> findByStatus(SupplierStatus status);
    
    Optional<Supplier> findByContactEmail(String contactEmail);
    
    @Query("SELECT s FROM Supplier s WHERE s.status = 'ACTIVE'")
    List<Supplier> findActiveSuppliers();
    
    @Query("SELECT s FROM Supplier s WHERE s.companyName ILIKE %:name% AND s.status = 'ACTIVE'")
    List<Supplier> findActiveSuppliersByName(@Param("name") String name);
}
