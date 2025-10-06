package com.vegnbio.api.modules.marketplace.repo;

import com.vegnbio.api.modules.marketplace.entity.Offer;
import com.vegnbio.api.modules.marketplace.entity.OfferStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface OfferRepository extends JpaRepository<Offer, Long> {
    
    List<Offer> findBySupplierId(Long supplierId);
    
    List<Offer> findBySupplierIdAndStatus(Long supplierId, OfferStatus status);
    
    List<Offer> findByStatus(OfferStatus status);
    
    @Query("SELECT o FROM Offer o WHERE o.status = 'PUBLISHED' ORDER BY o.createdAt DESC")
    List<Offer> findPublishedOffers();
    
    @Query("SELECT o FROM Offer o WHERE o.status = 'PUBLISHED' AND " +
           "(o.title ILIKE %:search% OR o.description ILIKE %:search%) " +
           "ORDER BY o.createdAt DESC")
    List<Offer> findPublishedOffersBySearch(@Param("search") String search);
    
    @Query("SELECT o FROM Offer o WHERE o.supplier.id = :supplierId AND o.status = 'PUBLISHED'")
    List<Offer> findPublishedOffersBySupplier(@Param("supplierId") Long supplierId);
}
