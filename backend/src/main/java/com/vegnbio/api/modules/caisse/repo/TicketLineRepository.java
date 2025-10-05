package com.vegnbio.api.modules.caisse.repo;

import com.vegnbio.api.modules.caisse.entity.TicketLine;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TicketLineRepository extends JpaRepository<TicketLine, Long> {
    
    List<TicketLine> findByTicketId(Long ticketId);
    
    List<TicketLine> findByTicketIdOrderById(Long ticketId);
}
