package com.vegnbio.api.modules.marketplace.controller;

import com.vegnbio.api.modules.marketplace.dto.CreateSupplierRequest;
import com.vegnbio.api.modules.marketplace.dto.SupplierDto;
import com.vegnbio.api.modules.marketplace.entity.SupplierStatus;
import com.vegnbio.api.modules.marketplace.service.SupplierService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/suppliers")
@RequiredArgsConstructor
public class SupplierController {

    private final SupplierService supplierService;

    @PostMapping
    public ResponseEntity<SupplierDto> createSupplier(@Valid @RequestBody CreateSupplierRequest request) {
        SupplierDto supplier = supplierService.createSupplier(request);
        return ResponseEntity.ok(supplier);
    }

    @GetMapping
    public ResponseEntity<List<SupplierDto>> getSuppliers(
            @RequestParam(required = false) String search
    ) {
        List<SupplierDto> suppliers;
        if (search != null && !search.trim().isEmpty()) {
            suppliers = supplierService.searchActiveSuppliers(search);
        } else {
            suppliers = supplierService.getActiveSuppliers();
        }
        return ResponseEntity.ok(suppliers);
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<SupplierDto>> getAllSuppliers() {
        List<SupplierDto> suppliers = supplierService.getAllSuppliers();
        return ResponseEntity.ok(suppliers);
    }

    @GetMapping("/{supplierId}")
    public ResponseEntity<SupplierDto> getSupplier(@PathVariable Long supplierId) {
        SupplierDto supplier = supplierService.getSupplierById(supplierId);
        return ResponseEntity.ok(supplier);
    }

    @PatchMapping("/{supplierId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<SupplierDto> updateSupplierStatus(
            @PathVariable Long supplierId,
            @RequestParam SupplierStatus status
    ) {
        SupplierDto supplier = supplierService.updateSupplierStatus(supplierId, status);
        return ResponseEntity.ok(supplier);
    }
}
