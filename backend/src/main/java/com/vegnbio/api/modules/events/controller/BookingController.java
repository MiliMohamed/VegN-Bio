package com.vegnbio.api.modules.events.controller;

import com.vegnbio.api.modules.events.dto.BookingDto;
import com.vegnbio.api.modules.events.dto.CreateBookingRequest;
import com.vegnbio.api.modules.events.dto.UpdateBookingStatusRequest;
import com.vegnbio.api.modules.events.service.BookingService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    @PostMapping
    public ResponseEntity<BookingDto> createBooking(@Valid @RequestBody CreateBookingRequest request) {
        BookingDto booking = bookingService.createBooking(request);
        return ResponseEntity.ok(booking);
    }

    @GetMapping("/event/{eventId}")
    public ResponseEntity<List<BookingDto>> getBookingsByEvent(@PathVariable Long eventId) {
        List<BookingDto> bookings = bookingService.getBookingsByEvent(eventId);
        return ResponseEntity.ok(bookings);
    }

    @GetMapping("/restaurant/{restaurantId}")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<BookingDto>> getBookingsByRestaurant(@PathVariable Long restaurantId) {
        List<BookingDto> bookings = bookingService.getBookingsByRestaurant(restaurantId);
        return ResponseEntity.ok(bookings);
    }

    @GetMapping("/{bookingId}")
    public ResponseEntity<BookingDto> getBooking(@PathVariable Long bookingId) {
        BookingDto booking = bookingService.getBookingById(bookingId);
        return ResponseEntity.ok(booking);
    }

    @PatchMapping("/{bookingId}/status")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<BookingDto> updateBookingStatus(
            @PathVariable Long bookingId,
            @Valid @RequestBody UpdateBookingStatusRequest request
    ) {
        BookingDto booking = bookingService.updateBookingStatus(bookingId, request);
        return ResponseEntity.ok(booking);
    }
}
