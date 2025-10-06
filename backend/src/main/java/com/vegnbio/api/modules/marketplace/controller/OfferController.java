package com.vegnbio.api.modules.marketplace.controller;

import com.vegnbio.api.modules.marketplace.dto.CreateOfferRequest;
import com.vegnbio.api.modules.marketplace.dto.OfferDto;
import com.vegnbio.api.modules.marketplace.dto.UpdateOfferStatusRequest;
import com.vegnbio.api.modules.marketplace.service.OfferService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/offers")
@RequiredArgsConstructor
public class OfferController {

    private final OfferService offerService;

    @PostMapping
    @PreAuthorize("hasRole('FOURNISSEUR')")
    public ResponseEntity<OfferDto> createOffer(@Valid @RequestBody CreateOfferRequest request) {
        OfferDto offer = offerService.createOffer(request);
        return ResponseEntity.ok(offer);
    }

    @GetMapping
    public ResponseEntity<List<OfferDto>> getOffers(
            @RequestParam(required = false) String search
    ) {
        List<OfferDto> offers;
        if (search != null && !search.trim().isEmpty()) {
            offers = offerService.searchPublishedOffers(search);
        } else {
            offers = offerService.getPublishedOffers();
        }
        return ResponseEntity.ok(offers);
    }

    @GetMapping("/supplier/{supplierId}")
    public ResponseEntity<List<OfferDto>> getOffersBySupplier(@PathVariable Long supplierId) {
        List<OfferDto> offers = offerService.getPublishedOffersBySupplier(supplierId);
        return ResponseEntity.ok(offers);
    }

    @GetMapping("/my-offers")
    @PreAuthorize("hasRole('FOURNISSEUR')")
    public ResponseEntity<List<OfferDto>> getMyOffers(
            @RequestParam Long supplierId
    ) {
        List<OfferDto> offers = offerService.getOffersBySupplier(supplierId);
        return ResponseEntity.ok(offers);
    }

    @GetMapping("/{offerId}")
    public ResponseEntity<OfferDto> getOffer(@PathVariable Long offerId) {
        OfferDto offer = offerService.getOfferById(offerId);
        return ResponseEntity.ok(offer);
    }

    @PatchMapping("/{offerId}/status")
    @PreAuthorize("hasRole('FOURNISSEUR')")
    public ResponseEntity<OfferDto> updateOfferStatus(
            @PathVariable Long offerId,
            @Valid @RequestBody UpdateOfferStatusRequest request
    ) {
        OfferDto offer = offerService.updateOfferStatus(offerId, request);
        return ResponseEntity.ok(offer);
    }
    
    @PutMapping("/{offerId}")
    @PreAuthorize("hasRole('FOURNISSEUR') or hasRole('ADMIN')")
    public ResponseEntity<OfferDto> updateOffer(@PathVariable Long offerId, @Valid @RequestBody CreateOfferRequest request) {
        OfferDto offer = offerService.updateOffer(offerId, request);
        return ResponseEntity.ok(offer);
    }
    
    @DeleteMapping("/{offerId}")
    @PreAuthorize("hasRole('FOURNISSEUR') or hasRole('ADMIN')")
    public ResponseEntity<Void> deleteOffer(@PathVariable Long offerId) {
        offerService.deleteOffer(offerId);
        return ResponseEntity.noContent().build();
    }
}
