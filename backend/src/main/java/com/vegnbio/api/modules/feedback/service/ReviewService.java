package com.vegnbio.api.modules.feedback.service;

import com.vegnbio.api.modules.feedback.dto.CreateReviewRequest;
import com.vegnbio.api.modules.feedback.dto.ReviewDto;
import com.vegnbio.api.modules.feedback.dto.UpdateReviewStatusRequest;
import com.vegnbio.api.modules.feedback.entity.Review;
import com.vegnbio.api.modules.feedback.entity.ReviewStatus;
import com.vegnbio.api.modules.feedback.repo.ReviewRepository;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final RestaurantRepository restaurantRepository;

    @Transactional
    public ReviewDto createReview(CreateReviewRequest request) {
        var restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        var review = Review.builder()
                .restaurant(restaurant)
                .customerName(request.customerName())
                .customerEmail(request.customerEmail())
                .rating(request.rating())
                .comment(request.comment())
                .status(ReviewStatus.PENDING)
                .build();
        
        reviewRepository.save(review);
        return toDto(review);
    }

    @Transactional(readOnly = true)
    public List<ReviewDto> getApprovedReviewsByRestaurant(Long restaurantId) {
        return reviewRepository.findByRestaurantIdAndStatus(restaurantId, ReviewStatus.APPROVED)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ReviewDto> getAllReviewsByRestaurant(Long restaurantId) {
        return reviewRepository.findByRestaurantId(restaurantId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<ReviewDto> getPendingReviews() {
        return reviewRepository.findByStatus(ReviewStatus.PENDING)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public ReviewDto getReviewById(Long reviewId) {
        var review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));
        return toDto(review);
    }

    @Transactional
    public ReviewDto updateReviewStatus(Long reviewId, UpdateReviewStatusRequest request) {
        var review = reviewRepository.findById(reviewId)
                .orElseThrow(() -> new RuntimeException("Review not found"));
        
        review.setStatus(request.status());
        reviewRepository.save(review);
        return toDto(review);
    }

    @Transactional(readOnly = true)
    public Double getAverageRating(Long restaurantId) {
        return reviewRepository.getAverageRatingByRestaurant(restaurantId);
    }

    @Transactional(readOnly = true)
    public Long getReviewsCount(Long restaurantId) {
        return reviewRepository.getApprovedReviewsCountByRestaurant(restaurantId);
    }

    private ReviewDto toDto(Review review) {
        return new ReviewDto(
                review.getId(),
                review.getRestaurant().getId(),
                review.getCustomerName(),
                review.getCustomerEmail(),
                review.getRating(),
                review.getComment(),
                review.getStatus(),
                review.getCreatedAt()
        );
    }
}
