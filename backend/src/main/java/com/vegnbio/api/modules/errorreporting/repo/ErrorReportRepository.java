package com.vegnbio.api.modules.errorreporting.repo;

import com.vegnbio.api.modules.errorreporting.entity.ErrorReport;
import com.vegnbio.api.modules.errorreporting.entity.ErrorSeverity;
import com.vegnbio.api.modules.errorreporting.entity.ErrorStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ErrorReportRepository extends JpaRepository<ErrorReport, Long> {
    
    List<ErrorReport> findByStatus(ErrorStatus status);
    
    List<ErrorReport> findBySeverity(ErrorSeverity severity);
    
    List<ErrorReport> findByStatusAndSeverity(ErrorStatus status, ErrorSeverity severity);
    
    List<ErrorReport> findByCreatedAtAfterOrderByCreatedAtDesc(LocalDateTime date);
    
    long countByStatus(ErrorStatus status);
    
    long countBySeverity(ErrorSeverity severity);
    
    long countByCreatedAtAfter(LocalDateTime date);
    
    @Query("SELECT er.errorType as errorType, COUNT(er) as count FROM ErrorReport er GROUP BY er.errorType ORDER BY count DESC")
    List<Object[]> findErrorTypeStatistics();
    
    @Query("SELECT er FROM ErrorReport er WHERE er.severity = :severity AND er.status = :status ORDER BY er.createdAt DESC")
    List<ErrorReport> findCriticalErrors(ErrorSeverity severity, ErrorStatus status);
}