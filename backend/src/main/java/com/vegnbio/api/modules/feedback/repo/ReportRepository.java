package com.vegnbio.api.modules.feedback.repo;

import com.vegnbio.api.modules.feedback.entity.Report;
import com.vegnbio.api.modules.feedback.entity.ReportStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Long> {
    
    List<Report> findByRestaurantId(Long restaurantId);
    
    List<Report> findByStatus(ReportStatus status);
    
    @Query("SELECT r FROM Report r WHERE r.status IN ('OPEN', 'IN_PROGRESS')")
    List<Report> findActiveReports();
    
    @Query("SELECT r FROM Report r WHERE r.restaurant.id = :restaurantId AND r.status IN ('OPEN', 'IN_PROGRESS')")
    List<Report> findActiveReportsByRestaurant(@Param("restaurantId") Long restaurantId);
}

