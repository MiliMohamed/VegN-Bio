package com.vegnbio.api.modules.feedback.controller;

import com.vegnbio.api.modules.feedback.dto.CreateReviewRequest;
import com.vegnbio.api.modules.feedback.dto.ReviewDto;
import com.vegnbio.api.modules.feedback.dto.UpdateReviewStatusRequest;
import com.vegnbio.api.modules.feedback.service.ReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    public ResponseEntity<ReviewDto> createReview(@Valid @RequestBody CreateReviewRequest request) {
        ReviewDto review = reviewService.createReview(request);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/restaurant/{restaurantId}")
    public ResponseEntity<List<ReviewDto>> getApprovedReviewsByRestaurant(@PathVariable Long restaurantId) {
        List<ReviewDto> reviews = reviewService.getApprovedReviewsByRestaurant(restaurantId);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/restaurant/{restaurantId}/all")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<ReviewDto>> getAllReviewsByRestaurant(@PathVariable Long restaurantId) {
        List<ReviewDto> reviews = reviewService.getAllReviewsByRestaurant(restaurantId);
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/pending")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<ReviewDto>> getPendingReviews() {
        List<ReviewDto> reviews = reviewService.getPendingReviews();
        return ResponseEntity.ok(reviews);
    }

    @GetMapping("/{reviewId}")
    public ResponseEntity<ReviewDto> getReview(@PathVariable Long reviewId) {
        ReviewDto review = reviewService.getReviewById(reviewId);
        return ResponseEntity.ok(review);
    }

    @PatchMapping("/{reviewId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ReviewDto> updateReviewStatus(
            @PathVariable Long reviewId,
            @Valid @RequestBody UpdateReviewStatusRequest request
    ) {
        ReviewDto review = reviewService.updateReviewStatus(reviewId, request);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/restaurant/{restaurantId}/stats")
    public ResponseEntity<Object> getRestaurantReviewStats(@PathVariable Long restaurantId) {
        Double avgRating = reviewService.getAverageRating(restaurantId);
        Long count = reviewService.getReviewsCount(restaurantId);
        
        return ResponseEntity.ok(new Object() {
            public final Double averageRating = avgRating;
            public final Long reviewsCount = count;
        });
    }
}
