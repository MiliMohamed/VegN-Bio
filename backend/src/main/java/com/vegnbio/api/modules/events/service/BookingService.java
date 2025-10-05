package com.vegnbio.api.modules.events.service;

import com.vegnbio.api.modules.events.dto.BookingDto;
import com.vegnbio.api.modules.events.dto.CreateBookingRequest;
import com.vegnbio.api.modules.events.dto.UpdateBookingStatusRequest;
import com.vegnbio.api.modules.events.entity.Booking;
import com.vegnbio.api.modules.events.entity.BookingStatus;
import com.vegnbio.api.modules.events.entity.Event;
import com.vegnbio.api.modules.events.entity.EventStatus;
import com.vegnbio.api.modules.events.repo.BookingRepository;
import com.vegnbio.api.modules.events.repo.EventRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final EventRepository eventRepository;

    @Transactional
    public BookingDto createBooking(CreateBookingRequest request) {
        var event = eventRepository.findById(request.eventId())
                .orElseThrow(() -> new RuntimeException("Event not found"));
        
        if (event.getStatus() != EventStatus.ACTIVE) {
            throw new RuntimeException("Cannot book for inactive or cancelled event");
        }
        
        // Vérifier la capacité si elle est définie
        if (event.getCapacity() != null) {
            Integer totalBooked = bookingRepository.getTotalConfirmedPaxForEvent(event.getId());
            int currentBooked = totalBooked != null ? totalBooked : 0;
            if (currentBooked + request.pax() > event.getCapacity()) {
                throw new RuntimeException("Not enough capacity for this booking");
            }
        }
        
        var booking = Booking.builder()
                .event(event)
                .customerName(request.customerName())
                .customerPhone(request.customerPhone())
                .pax(request.pax())
                .status(BookingStatus.PENDING)
                .build();
        
        bookingRepository.save(booking);
        return toDto(booking);
    }

    @Transactional(readOnly = true)
    public List<BookingDto> getBookingsByEvent(Long eventId) {
        return bookingRepository.findByEventId(eventId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<BookingDto> getBookingsByRestaurant(Long restaurantId) {
        return bookingRepository.findByRestaurantId(restaurantId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public BookingDto updateBookingStatus(Long bookingId, UpdateBookingStatusRequest request) {
        var booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
        
        booking.setStatus(request.status());
        bookingRepository.save(booking);
        return toDto(booking);
    }

    @Transactional(readOnly = true)
    public BookingDto getBookingById(Long bookingId) {
        var booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));
        return toDto(booking);
    }

    private BookingDto toDto(Booking booking) {
        return new BookingDto(
                booking.getId(),
                booking.getEvent().getId(),
                booking.getCustomerName(),
                booking.getCustomerPhone(),
                booking.getPax(),
                booking.getStatus(),
                booking.getCreatedAt()
        );
    }
}
