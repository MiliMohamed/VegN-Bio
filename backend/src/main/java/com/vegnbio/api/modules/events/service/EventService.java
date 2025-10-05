package com.vegnbio.api.modules.events.service;

import com.vegnbio.api.modules.events.dto.CreateEventRequest;
import com.vegnbio.api.modules.events.dto.EventDto;
import com.vegnbio.api.modules.events.entity.Event;
import com.vegnbio.api.modules.events.entity.EventStatus;
import com.vegnbio.api.modules.events.repo.EventRepository;
import com.vegnbio.api.modules.events.repo.BookingRepository;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EventService {

    private final EventRepository eventRepository;
    private final BookingRepository bookingRepository;
    private final RestaurantRepository restaurantRepository;

    @Transactional
    public EventDto createEvent(CreateEventRequest request) {
        var restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        var event = Event.builder()
                .restaurant(restaurant)
                .title(request.title())
                .type(request.type())
                .dateStart(request.dateStart())
                .dateEnd(request.dateEnd())
                .capacity(request.capacity())
                .description(request.description())
                .status(EventStatus.ACTIVE)
                .build();
        
        eventRepository.save(event);
        return toDto(event);
    }

    @Transactional(readOnly = true)
    public List<EventDto> getEventsByRestaurant(Long restaurantId, LocalDateTime from, LocalDateTime to) {
        List<Event> events;
        if (from != null && to != null) {
            events = eventRepository.findByRestaurantIdAndDateRangeAndStatus(
                    restaurantId, from, to, EventStatus.ACTIVE);
        } else {
            events = eventRepository.findByRestaurantIdAndStatus(restaurantId, EventStatus.ACTIVE);
        }
        
        return events.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EventDto> getActiveEventsFromDate(LocalDateTime from) {
        return eventRepository.findActiveEventsFromDate(from)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public EventDto getEventById(Long eventId) {
        var event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        return toDto(event);
    }

    @Transactional
    public EventDto cancelEvent(Long eventId) {
        var event = eventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        
        event.setStatus(EventStatus.CANCELLED);
        eventRepository.save(event);
        return toDto(event);
    }

    private EventDto toDto(Event event) {
        Integer availableSpots = null;
        if (event.getCapacity() != null) {
            Integer totalBooked = bookingRepository.getTotalConfirmedPaxForEvent(event.getId());
            availableSpots = event.getCapacity() - (totalBooked != null ? totalBooked : 0);
        }
        
        return new EventDto(
                event.getId(),
                event.getRestaurant().getId(),
                event.getTitle(),
                event.getType(),
                event.getDateStart(),
                event.getDateEnd(),
                event.getCapacity(),
                event.getDescription(),
                event.getStatus(),
                availableSpots
        );
    }
}
