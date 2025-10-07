package com.vegnbio.api.modules.errorreporting.repo;

import com.vegnbio.api.modules.errorreporting.entity.ErrorReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Repository
public interface ErrorReportRepository extends JpaRepository<ErrorReport, Long> {
    
    List<ErrorReport> findByUserIdOrderByTimestampDesc(String userId);
    
    List<ErrorReport> findByErrorTypeOrderByTimestampDesc(String errorType);
    
    List<ErrorReport> findByTimestampBetweenOrderByTimestampDesc(LocalDateTime startDate, LocalDateTime endDate);
    
    @Query("SELECT e.errorType, COUNT(e) FROM ErrorReport e GROUP BY e.errorType")
    List<Object[]> countErrorsByType();
    
    @Query("SELECT e.userId, COUNT(e) FROM ErrorReport e WHERE e.userId IS NOT NULL GROUP BY e.userId")
    List<Object[]> countErrorsByUser();
    
    @Query("SELECT e.deviceInfo, COUNT(e) FROM ErrorReport e WHERE e.deviceInfo IS NOT NULL GROUP BY e.deviceInfo")
    List<Object[]> countErrorsByDevice();
    
    @Query("SELECT COUNT(e) FROM ErrorReport e WHERE e.timestamp BETWEEN :startDate AND :endDate")
    Long countErrorsByDateRange(@Param("startDate") LocalDateTime startDate, 
                               @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(e) FROM ErrorReport e WHERE e.errorType = :errorType AND e.timestamp BETWEEN :startDate AND :endDate")
    Long countErrorsByTypeAndDateRange(@Param("errorType") String errorType,
                                      @Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate);
}
