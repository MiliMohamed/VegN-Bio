package com.vegnbio.api.modules.room.controller;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.room.dto.*;
import com.vegnbio.api.modules.room.service.RoomService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/v1/rooms")
@RequiredArgsConstructor
@Tag(name = "Room Management", description = "Gestion des salles et réservations")
public class RoomController {
    
    private final RoomService roomService;
    
    // === GESTION DES SALLES ===
    
    @PostMapping
    @Operation(summary = "Créer une nouvelle salle")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<RoomDto> createRoom(@RequestBody CreateRoomRequest request) {
        RoomDto room = roomService.createRoom(request);
        return ResponseEntity.ok(room);
    }
    
    @PutMapping("/{roomId}")
    @Operation(summary = "Modifier une salle")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<RoomDto> updateRoom(
            @PathVariable Long roomId,
            @RequestBody UpdateRoomRequest request) {
        RoomDto room = roomService.updateRoom(roomId, request);
        return ResponseEntity.ok(room);
    }
    
    @GetMapping("/restaurant/{restaurantId}")
    @Operation(summary = "Récupérer les salles d'un restaurant")
    public ResponseEntity<List<RoomDto>> getRoomsByRestaurant(@PathVariable Long restaurantId) {
        List<RoomDto> rooms = roomService.getRoomsByRestaurant(restaurantId);
        return ResponseEntity.ok(rooms);
    }
    
    @GetMapping("/restaurant/{restaurantId}/available")
    @Operation(summary = "Récupérer les salles disponibles d'un restaurant")
    public ResponseEntity<List<RoomDto>> getAvailableRooms(
            @PathVariable Long restaurantId,
            @RequestParam(required = false) Integer minCapacity) {
        List<RoomDto> rooms = roomService.getAvailableRooms(restaurantId, minCapacity);
        return ResponseEntity.ok(rooms);
    }
    
    @GetMapping("/{roomId}")
    @Operation(summary = "Récupérer les détails d'une salle")
    public ResponseEntity<RoomDto> getRoomById(@PathVariable Long roomId) {
        RoomDto room = roomService.getRoomById(roomId);
        return ResponseEntity.ok(room);
    }
    
    @DeleteMapping("/{roomId}")
    @Operation(summary = "Supprimer une salle")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<Void> deleteRoom(@PathVariable Long roomId) {
        roomService.deleteRoom(roomId);
        return ResponseEntity.noContent().build();
    }
    
    // === GESTION DES RÉSERVATIONS ===
    
    @PostMapping("/{roomId}/reservations")
    @Operation(summary = "Créer une réservation de salle")
    public ResponseEntity<RoomReservationDto> createReservation(
            @AuthenticationPrincipal User user,
            @PathVariable Long roomId,
            @RequestBody CreateReservationRequest request) {
        request.setRoomId(roomId);
        RoomReservationDto reservation = roomService.createReservation(user, request);
        return ResponseEntity.ok(reservation);
    }
    
    @PutMapping("/reservations/{reservationId}")
    @Operation(summary = "Modifier une réservation")
    public ResponseEntity<RoomReservationDto> updateReservation(
            @AuthenticationPrincipal User user,
            @PathVariable Long reservationId,
            @RequestBody UpdateReservationRequest request) {
        RoomReservationDto reservation = roomService.updateReservation(user, reservationId, request);
        return ResponseEntity.ok(reservation);
    }
    
    @GetMapping("/reservations/my")
    @Operation(summary = "Récupérer mes réservations")
    public ResponseEntity<List<RoomReservationDto>> getMyReservations(@AuthenticationPrincipal User user) {
        List<RoomReservationDto> reservations = roomService.getUserReservations(user);
        return ResponseEntity.ok(reservations);
    }
    
    @GetMapping("/{roomId}/reservations")
    @Operation(summary = "Récupérer les réservations d'une salle")
    public ResponseEntity<List<RoomReservationDto>> getRoomReservations(@PathVariable Long roomId) {
        List<RoomReservationDto> reservations = roomService.getRoomReservations(roomId);
        return ResponseEntity.ok(reservations);
    }
    
    @GetMapping("/restaurant/{restaurantId}/reservations")
    @Operation(summary = "Récupérer les réservations d'un restaurant")
    @PreAuthorize("hasRole('RESTAURATEUR') or hasRole('ADMIN')")
    public ResponseEntity<List<RoomReservationDto>> getRestaurantReservations(@PathVariable Long restaurantId) {
        List<RoomReservationDto> reservations = roomService.getRestaurantReservations(restaurantId);
        return ResponseEntity.ok(reservations);
    }
    
    @GetMapping("/reservations/{reservationId}")
    @Operation(summary = "Récupérer les détails d'une réservation")
    public ResponseEntity<RoomReservationDto> getReservationById(@PathVariable Long reservationId) {
        RoomReservationDto reservation = roomService.getReservationById(reservationId);
        return ResponseEntity.ok(reservation);
    }
    
    @PostMapping("/reservations/{reservationId}/cancel")
    @Operation(summary = "Annuler une réservation")
    public ResponseEntity<Void> cancelReservation(
            @AuthenticationPrincipal User user,
            @PathVariable Long reservationId) {
        roomService.cancelReservation(user, reservationId);
        return ResponseEntity.noContent().build();
    }
    
    // === VÉRIFICATION DE DISPONIBILITÉ ===
    
    @GetMapping("/{roomId}/availability")
    @Operation(summary = "Vérifier la disponibilité d'une salle")
    public ResponseEntity<List<RoomAvailabilityDto>> checkAvailability(
            @PathVariable Long roomId,
            @RequestParam LocalDateTime startTime,
            @RequestParam LocalDateTime endTime) {
        List<RoomAvailabilityDto> availability = roomService.checkRoomAvailability(roomId, startTime, endTime);
        return ResponseEntity.ok(availability);
    }
}
