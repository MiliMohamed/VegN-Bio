package com.vegnbio.api.modules.marketplace.service;

import com.vegnbio.api.modules.marketplace.dto.CreateSupplierRequest;
import com.vegnbio.api.modules.marketplace.dto.SupplierDto;
import com.vegnbio.api.modules.marketplace.entity.Supplier;
import com.vegnbio.api.modules.marketplace.entity.SupplierStatus;
import com.vegnbio.api.modules.marketplace.repo.SupplierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SupplierService {

    private final SupplierRepository supplierRepository;

    @Transactional
    public SupplierDto createSupplier(CreateSupplierRequest request) {
        // Vérifier si l'email existe déjà
        if (supplierRepository.findByContactEmail(request.contactEmail()).isPresent()) {
            throw new RuntimeException("Supplier with this email already exists");
        }

        var supplier = Supplier.builder()
                .companyName(request.companyName())
                .contactEmail(request.contactEmail())
                .contactPhone(request.contactPhone())
                .address(request.address())
                .city(request.city())
                .description(request.description())
                .status(SupplierStatus.ACTIVE)
                .build();
        
        supplierRepository.save(supplier);
        return toDto(supplier);
    }

    @Transactional(readOnly = true)
    public List<SupplierDto> getAllSuppliers() {
        return supplierRepository.findAll()
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<SupplierDto> getActiveSuppliers() {
        return supplierRepository.findActiveSuppliers()
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<SupplierDto> searchActiveSuppliers(String name) {
        return supplierRepository.findActiveSuppliersByName(name)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public SupplierDto getSupplierById(Long supplierId) {
        var supplier = supplierRepository.findById(supplierId)
                .orElseThrow(() -> new RuntimeException("Supplier not found"));
        return toDto(supplier);
    }

    @Transactional
    public SupplierDto updateSupplierStatus(Long supplierId, SupplierStatus status) {
        var supplier = supplierRepository.findById(supplierId)
                .orElseThrow(() -> new RuntimeException("Supplier not found"));
        
        supplier.setStatus(status);
        supplierRepository.save(supplier);
        return toDto(supplier);
    }
    
    @Transactional
    public SupplierDto updateSupplier(Long supplierId, CreateSupplierRequest request) {
        Supplier supplier = supplierRepository.findById(supplierId)
                .orElseThrow(() -> new RuntimeException("Supplier not found"));
        
        supplier.setCompanyName(request.companyName());
        supplier.setContactEmail(request.contactEmail());
        
        Supplier savedSupplier = supplierRepository.save(supplier);
        return toDto(savedSupplier);
    }
    
    @Transactional
    public void deleteSupplier(Long supplierId) {
        if (!supplierRepository.existsById(supplierId)) {
            throw new RuntimeException("Supplier not found");
        }
        supplierRepository.deleteById(supplierId);
    }
    
    private SupplierDto toDto(Supplier supplier) {
        return new SupplierDto(
                supplier.getId(),
                supplier.getCompanyName(),
                supplier.getContactEmail(),
                supplier.getContactPhone(),
                supplier.getAddress(),
                supplier.getCity(),
                supplier.getDescription(),
                supplier.getStatus(),
                supplier.getCreatedAt()
        );
    }
}
