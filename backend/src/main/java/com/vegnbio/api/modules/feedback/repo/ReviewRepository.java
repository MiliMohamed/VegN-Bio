package com.vegnbio.api.modules.feedback.repo;

import com.vegnbio.api.modules.feedback.entity.Review;
import com.vegnbio.api.modules.feedback.entity.ReviewStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    
    List<Review> findByRestaurantId(Long restaurantId);
    
    List<Review> findByRestaurantIdAndStatus(Long restaurantId, ReviewStatus status);
    
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.restaurant.id = :restaurantId AND r.status = 'APPROVED'")
    Double getAverageRatingByRestaurant(@Param("restaurantId") Long restaurantId);
    
    @Query("SELECT COUNT(r) FROM Review r WHERE r.restaurant.id = :restaurantId AND r.status = 'APPROVED'")
    Long getApprovedReviewsCountByRestaurant(@Param("restaurantId") Long restaurantId);
    
    List<Review> findByStatus(ReviewStatus status);
}
