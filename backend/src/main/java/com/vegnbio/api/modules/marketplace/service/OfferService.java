package com.vegnbio.api.modules.marketplace.service;

import com.vegnbio.api.modules.marketplace.dto.CreateOfferRequest;
import com.vegnbio.api.modules.marketplace.dto.OfferDto;
import com.vegnbio.api.modules.marketplace.dto.UpdateOfferStatusRequest;
import com.vegnbio.api.modules.marketplace.entity.Offer;
import com.vegnbio.api.modules.marketplace.entity.OfferStatus;
import com.vegnbio.api.modules.marketplace.entity.Supplier;
import com.vegnbio.api.modules.marketplace.repo.OfferRepository;
import com.vegnbio.api.modules.marketplace.repo.SupplierRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OfferService {

    private final OfferRepository offerRepository;
    private final SupplierRepository supplierRepository;

    @Transactional
    public OfferDto createOffer(CreateOfferRequest request) {
        var supplier = supplierRepository.findById(request.supplierId())
                .orElseThrow(() -> new RuntimeException("Supplier not found"));
        
        if (supplier.getStatus() != com.vegnbio.api.modules.marketplace.entity.SupplierStatus.ACTIVE) {
            throw new RuntimeException("Cannot create offer for inactive supplier");
        }

        var offer = Offer.builder()
                .supplier(supplier)
                .title(request.title())
                .description(request.description())
                .unitPriceCents(request.unitPriceCents())
                .unit(request.unit())
                .status(OfferStatus.DRAFT)
                .build();
        
        offerRepository.save(offer);
        return toDto(offer);
    }

    @Transactional(readOnly = true)
    public List<OfferDto> getPublishedOffers() {
        return offerRepository.findPublishedOffers()
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OfferDto> searchPublishedOffers(String search) {
        return offerRepository.findPublishedOffersBySearch(search)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OfferDto> getOffersBySupplier(Long supplierId) {
        return offerRepository.findBySupplierId(supplierId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OfferDto> getPublishedOffersBySupplier(Long supplierId) {
        return offerRepository.findPublishedOffersBySupplier(supplierId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public OfferDto getOfferById(Long offerId) {
        var offer = offerRepository.findById(offerId)
                .orElseThrow(() -> new RuntimeException("Offer not found"));
        return toDto(offer);
    }

    @Transactional
    public OfferDto updateOfferStatus(Long offerId, UpdateOfferStatusRequest request) {
        var offer = offerRepository.findById(offerId)
                .orElseThrow(() -> new RuntimeException("Offer not found"));
        
        offer.setStatus(request.status());
        offerRepository.save(offer);
        return toDto(offer);
    }

    private OfferDto toDto(Offer offer) {
        return new OfferDto(
                offer.getId(),
                offer.getSupplier().getId(),
                offer.getSupplier().getCompanyName(),
                offer.getTitle(),
                offer.getDescription(),
                offer.getUnitPriceCents(),
                offer.getUnit(),
                offer.getStatus(),
                offer.getCreatedAt(),
                offer.getUpdatedAt()
        );
    }
}
