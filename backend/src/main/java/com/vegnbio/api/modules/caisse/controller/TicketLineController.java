package com.vegnbio.api.modules.caisse.controller;

import com.vegnbio.api.modules.caisse.dto.CreateTicketLineRequest;
import com.vegnbio.api.modules.caisse.dto.TicketLineDto;
import com.vegnbio.api.modules.caisse.service.TicketLineService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/tickets/{ticketId}/lines")
@RequiredArgsConstructor
public class TicketLineController {

    private final TicketLineService ticketLineService;

    @PostMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<TicketLineDto> createTicketLine(
            @PathVariable("ticketId") Long ticketId,
            @Valid @RequestBody CreateTicketLineRequest request
    ) {
        TicketLineDto ticketLine = ticketLineService.createTicketLine(ticketId, request);
        return ResponseEntity.ok(ticketLine);
    }

    @GetMapping
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<List<TicketLineDto>> getTicketLines(@PathVariable("ticketId") Long ticketId) {
        List<TicketLineDto> ticketLines = ticketLineService.getTicketLinesByTicket(ticketId);
        return ResponseEntity.ok(ticketLines);
    }

    @PatchMapping("/{ticketLineId}")
    @PreAuthorize("hasRole('RESTAURATEUR')")
    public ResponseEntity<Void> deleteTicketLine(
            @PathVariable("ticketId") Long ticketId,
            @PathVariable("ticketLineId") Long ticketLineId
    ) {
        // Optionnel mais conseillé : vérifier l'appartenance de la ligne au ticket
        ticketLineService.deleteTicketLine(ticketId, ticketLineId);
        return ResponseEntity.noContent().build(); // 204 pour un DELETE
    }
}
