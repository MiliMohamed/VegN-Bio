package com.vegnbio.api.modules.events.controller;

import com.vegnbio.api.modules.events.dto.CreateEventRequest;
import com.vegnbio.api.modules.events.dto.EventDto;
import com.vegnbio.api.modules.events.service.EventService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/events")
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    @PostMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<EventDto> createEvent(@Valid @RequestBody CreateEventRequest request) {
        EventDto event = eventService.createEvent(request);
        return ResponseEntity.ok(event);
    }

    @GetMapping
    public ResponseEntity<List<EventDto>> getEvents(
            @RequestParam(required = false) Long restaurantId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        List<EventDto> events;
        if (restaurantId != null) {
            events = eventService.getEventsByRestaurant(restaurantId, from, to);
        } else {
            events = eventService.getActiveEventsFromDate(LocalDateTime.now());
        }
        return ResponseEntity.ok(events);
    }

    @GetMapping("/{eventId}")
    public ResponseEntity<EventDto> getEvent(@PathVariable Long eventId) {
        EventDto event = eventService.getEventById(eventId);
        return ResponseEntity.ok(event);
    }

    @PatchMapping("/{eventId}/cancel")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<EventDto> cancelEvent(@PathVariable Long eventId) {
        EventDto event = eventService.cancelEvent(eventId);
        return ResponseEntity.ok(event);
    }
}
