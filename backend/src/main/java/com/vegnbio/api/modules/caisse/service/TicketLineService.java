package com.vegnbio.api.modules.caisse.service;

import com.vegnbio.api.modules.caisse.dto.CreateTicketLineRequest;
import com.vegnbio.api.modules.caisse.dto.TicketLineDto;
import com.vegnbio.api.modules.caisse.entity.Ticket;
import com.vegnbio.api.modules.caisse.entity.TicketLine;
import com.vegnbio.api.modules.caisse.entity.TicketStatus;
import com.vegnbio.api.modules.caisse.repo.TicketLineRepository;
import com.vegnbio.api.modules.caisse.repo.TicketRepository;
import com.vegnbio.api.modules.menu.repo.MenuItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TicketLineService {

    private final TicketLineRepository ticketLineRepository;
    private final TicketRepository ticketRepository;
    private final MenuItemRepository menuItemRepository;

    @Transactional
    public TicketLineDto createTicketLine(Long ticketId, CreateTicketLineRequest request) {
        var ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        
        if (ticket.getStatus() == TicketStatus.CLOSED) {
            throw new RuntimeException("Cannot add items to a closed ticket");
        }
        
        var menuItem = menuItemRepository.findById(request.menuItemId())
                .orElseThrow(() -> new RuntimeException("Menu item not found"));
        
        var ticketLine = TicketLine.builder()
                .ticket(ticket)
                .menuItem(menuItem)
                .qty(request.qty())
                .unitPriceCents(menuItem.getPriceCents())
                .build();
        
        ticketLineRepository.save(ticketLine);
        
        // Recalculate ticket total
        ticket.calculateTotal();
        ticketRepository.save(ticket);
        
        return toDto(ticketLine);
    }

    @Transactional(readOnly = true)
    public List<TicketLineDto> getTicketLinesByTicket(Long ticketId) {
        return ticketLineRepository.findByTicketIdOrderById(ticketId)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional
    public void deleteTicketLine(Long ticketId, Long ticketLineId) {
        var ticketLine = ticketLineRepository.findById(ticketLineId)
                .orElseThrow(() -> new RuntimeException("Ticket line not found"));
        
        // Vérifier que la ligne appartient au bon ticket
        if (!ticketLine.getTicket().getId().equals(ticketId)) {
            throw new RuntimeException("Ticket line does not belong to the specified ticket");
        }
        
        var ticket = ticketLine.getTicket();
        if (ticket.getStatus() == TicketStatus.CLOSED) {
            throw new RuntimeException("Cannot modify a closed ticket");
        }
        
        ticketLineRepository.delete(ticketLine);
        
        // Recalculate ticket total
        ticket.calculateTotal();
        ticketRepository.save(ticket);
    }

    private TicketLineDto toDto(TicketLine line) {
        return new TicketLineDto(
                line.getId(),
                line.getTicket().getId(),
                line.getMenuItem().getId(),
                line.getMenuItem().getName(),
                line.getQty(),
                line.getUnitPriceCents(),
                line.getLineTotalCents()
        );
    }
}
