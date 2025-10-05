package com.vegnbio.api.modules.caisse.service;

import com.vegnbio.api.modules.caisse.dto.CreateTicketRequest;
import com.vegnbio.api.modules.caisse.dto.TicketDto;
import com.vegnbio.api.modules.caisse.entity.Ticket;
import com.vegnbio.api.modules.caisse.entity.TicketStatus;
import com.vegnbio.api.modules.caisse.repo.TicketRepository;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TicketService {

    private final TicketRepository ticketRepository;
    private final RestaurantRepository restaurantRepository;

    @Transactional
    public TicketDto createTicket(CreateTicketRequest request) {
        var restaurant = restaurantRepository.findById(request.restaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));

        var ticket = Ticket.builder()
                .restaurant(restaurant)
                .openedAt(LocalDateTime.now())
                .totalCents(0)
                .status(TicketStatus.OPEN)
                .build();
        
        ticketRepository.save(ticket);
        return toDto(ticket);
    }

    @Transactional
    public TicketDto closeTicket(Long ticketId) {
        var ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        
        if (ticket.getStatus() == TicketStatus.CLOSED) {
            throw new RuntimeException("Ticket is already closed");
        }
        
        ticket.close();
        ticketRepository.save(ticket);
        return toDto(ticket);
    }

    @Transactional(readOnly = true)
    public List<TicketDto> getTicketsByRestaurant(Long restaurantId, LocalDateTime from, LocalDateTime to) {
        List<Ticket> tickets;
        if (from != null || to != null) {
            tickets = ticketRepository.findByRestaurantIdAndDateRange(restaurantId, from, to);
        } else {
            tickets = ticketRepository.findByRestaurantId(restaurantId);
        }
        
        return tickets.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<TicketDto> getOpenTicketsByRestaurant(Long restaurantId) {
        return ticketRepository.findByRestaurantIdAndStatus(restaurantId, TicketStatus.OPEN)
                .stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public TicketDto getTicketById(Long ticketId) {
        var ticket = ticketRepository.findById(ticketId)
                .orElseThrow(() -> new RuntimeException("Ticket not found"));
        return toDto(ticket);
    }

    private TicketDto toDto(Ticket ticket) {
        return new TicketDto(
                ticket.getId(),
                ticket.getRestaurant().getId(),
                ticket.getOpenedAt(),
                ticket.getClosedAt(),
                ticket.getTotalCents(),
                ticket.getStatus(),
                ticket.getTicketLines() != null ? 
                    ticket.getTicketLines().stream()
                            .map(this::toLineDto)
                            .collect(Collectors.toList()) : 
                    List.of()
        );
    }

    private com.vegnbio.api.modules.caisse.dto.TicketLineDto toLineDto(com.vegnbio.api.modules.caisse.entity.TicketLine line) {
        return new com.vegnbio.api.modules.caisse.dto.TicketLineDto(
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
