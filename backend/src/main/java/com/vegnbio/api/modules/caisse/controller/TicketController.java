package com.vegnbio.api.modules.caisse.controller;

import com.vegnbio.api.modules.caisse.dto.CreateTicketRequest;
import com.vegnbio.api.modules.caisse.dto.TicketDto;
import com.vegnbio.api.modules.caisse.service.TicketService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/tickets")
@RequiredArgsConstructor
public class TicketController {

    private final TicketService ticketService;

    @PostMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<TicketDto> createTicket(@Valid @RequestBody CreateTicketRequest request) {
        TicketDto ticket = ticketService.createTicket(request);
        return ResponseEntity.ok(ticket);
    }

    @PatchMapping("/{ticketId}/close")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<TicketDto> closeTicket(@PathVariable Long ticketId) {
        TicketDto ticket = ticketService.closeTicket(ticketId);
        return ResponseEntity.ok(ticket);
    }

    @GetMapping("/{ticketId}")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<TicketDto> getTicket(@PathVariable Long ticketId) {
        TicketDto ticket = ticketService.getTicketById(ticketId);
        return ResponseEntity.ok(ticket);
    }

    @GetMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<TicketDto>> getTickets(
            @RequestParam Long restaurantId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime to
    ) {
        List<TicketDto> tickets = ticketService.getTicketsByRestaurant(restaurantId, from, to);
        return ResponseEntity.ok(tickets);
    }

    @GetMapping("/open")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<TicketDto>> getOpenTickets(@RequestParam Long restaurantId) {
        List<TicketDto> tickets = ticketService.getOpenTicketsByRestaurant(restaurantId);
        return ResponseEntity.ok(tickets);
    }
}
