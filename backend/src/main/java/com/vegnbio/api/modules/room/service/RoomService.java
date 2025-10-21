package com.vegnbio.api.modules.room.service;

import com.vegnbio.api.modules.auth.entity.User;
import com.vegnbio.api.modules.restaurant.entity.Restaurant;
import com.vegnbio.api.modules.restaurant.repo.RestaurantRepository;
import com.vegnbio.api.modules.room.dto.*;
import com.vegnbio.api.modules.room.entity.Room;
import com.vegnbio.api.modules.room.entity.RoomReservation;
import com.vegnbio.api.modules.room.repository.RoomRepository;
import com.vegnbio.api.modules.room.repository.RoomReservationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class RoomService {
    
    private final RoomRepository roomRepository;
    private final RoomReservationRepository reservationRepository;
    private final RestaurantRepository restaurantRepository;
    
    // === GESTION DES SALLES ===
    
    public RoomDto createRoom(CreateRoomRequest request) {
        Restaurant restaurant = restaurantRepository.findById(request.getRestaurantId())
                .orElseThrow(() -> new RuntimeException("Restaurant not found"));
        
        Room room = Room.builder()
                .restaurant(restaurant)
                .name(request.getName())
                .description(request.getDescription())
                .capacity(request.getCapacity())
                .hourlyRateCents(request.getHourlyRateCents())
                .hasWifi(request.getHasWifi() != null ? request.getHasWifi() : false)
                .hasPrinter(request.getHasPrinter() != null ? request.getHasPrinter() : false)
                .hasProjector(request.getHasProjector() != null ? request.getHasProjector() : false)
                .hasWhiteboard(request.getHasWhiteboard() != null ? request.getHasWhiteboard() : false)
                .status(Room.RoomStatus.AVAILABLE)
                .build();
        
        room = roomRepository.save(room);
        return convertRoomToDto(room);
    }
    
    public RoomDto updateRoom(Long roomId, UpdateRoomRequest request) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
        
        if (request.getName() != null) room.setName(request.getName());
        if (request.getDescription() != null) room.setDescription(request.getDescription());
        if (request.getCapacity() != null) room.setCapacity(request.getCapacity());
        if (request.getHourlyRateCents() != null) room.setHourlyRateCents(request.getHourlyRateCents());
        if (request.getHasWifi() != null) room.setHasWifi(request.getHasWifi());
        if (request.getHasPrinter() != null) room.setHasPrinter(request.getHasPrinter());
        if (request.getHasProjector() != null) room.setHasProjector(request.getHasProjector());
        if (request.getHasWhiteboard() != null) room.setHasWhiteboard(request.getHasWhiteboard());
        if (request.getStatus() != null) room.setStatus(Room.RoomStatus.valueOf(request.getStatus()));
        
        room = roomRepository.save(room);
        return convertRoomToDto(room);
    }
    
    public List<RoomDto> getRoomsByRestaurant(Long restaurantId) {
        List<Room> rooms = roomRepository.findByRestaurant(
                restaurantRepository.findById(restaurantId)
                        .orElseThrow(() -> new RuntimeException("Restaurant not found")));
        
        return rooms.stream()
                .map(this::convertRoomToDto)
                .collect(Collectors.toList());
    }
    
    public List<RoomDto> getAvailableRooms(Long restaurantId, Integer minCapacity) {
        List<Room> rooms;
        if (minCapacity != null) {
            rooms = roomRepository.findAvailableRoomsByRestaurantAndMinCapacity(restaurantId, minCapacity);
        } else {
            rooms = roomRepository.findAvailableRoomsByRestaurant(restaurantId);
        }
        
        return rooms.stream()
                .map(this::convertRoomToDto)
                .collect(Collectors.toList());
    }
    
    public RoomDto getRoomById(Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
        
        return convertRoomToDto(room);
    }
    
    public void deleteRoom(Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
        
        // Vérifier s'il y a des réservations actives
        List<RoomReservation> activeReservations = reservationRepository.findActiveReservationsByRoom(roomId);
        if (!activeReservations.isEmpty()) {
            throw new RuntimeException("Cannot delete room with active reservations");
        }
        
        roomRepository.delete(room);
    }
    
    // === GESTION DES RÉSERVATIONS ===
    
    public RoomReservationDto createReservation(User user, CreateReservationRequest request) {
        Room room = roomRepository.findById(request.getRoomId())
                .orElseThrow(() -> new RuntimeException("Room not found"));
        
        // Vérifier la disponibilité
        List<RoomReservation> conflicts = reservationRepository.findConflictingReservations(
                request.getRoomId(), request.getStartTime(), request.getEndTime());
        
        if (!conflicts.isEmpty()) {
            throw new RuntimeException("Room is not available for the requested time slot");
        }
        
        // Vérifier que la salle est disponible
        if (room.getStatus() != Room.RoomStatus.AVAILABLE) {
            throw new RuntimeException("Room is not available for reservations");
        }
        
        RoomReservation reservation = RoomReservation.builder()
                .room(room)
                .user(user)
                .reservationDate(LocalDateTime.now())
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .purpose(request.getPurpose())
                .attendeesCount(request.getAttendeesCount())
                .specialRequirements(request.getSpecialRequirements())
                .notes(request.getNotes())
                .status(RoomReservation.ReservationStatus.PENDING)
                .build();
        
        reservation.setTotalPriceCents(reservation.calculateTotalPrice());
        
        reservation = reservationRepository.save(reservation);
        return convertReservationToDto(reservation);
    }
    
    public RoomReservationDto updateReservation(User user, Long reservationId, UpdateReservationRequest request) {
        RoomReservation reservation = reservationRepository.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
        
        // Vérifier que l'utilisateur est propriétaire de la réservation ou est admin
        if (!reservation.getUser().getId().equals(user.getId()) && !user.getRole().name().equals("ADMIN")) {
            throw new RuntimeException("Unauthorized access to reservation");
        }
        
        // Vérifier les conflits si les horaires changent
        if (request.getStartTime() != null || request.getEndTime() != null) {
            LocalDateTime startTime = request.getStartTime() != null ? request.getStartTime() : reservation.getStartTime();
            LocalDateTime endTime = request.getEndTime() != null ? request.getEndTime() : reservation.getEndTime();
            
            List<RoomReservation> conflicts = reservationRepository.findConflictingReservationsExcluding(
                    reservation.getRoom().getId(), startTime, endTime, reservationId);
            
            if (!conflicts.isEmpty()) {
                throw new RuntimeException("Room is not available for the requested time slot");
            }
        }
        
        if (request.getStartTime() != null) reservation.setStartTime(request.getStartTime());
        if (request.getEndTime() != null) reservation.setEndTime(request.getEndTime());
        if (request.getPurpose() != null) reservation.setPurpose(request.getPurpose());
        if (request.getAttendeesCount() != null) reservation.setAttendeesCount(request.getAttendeesCount());
        if (request.getSpecialRequirements() != null) reservation.setSpecialRequirements(request.getSpecialRequirements());
        if (request.getStatus() != null) reservation.setStatus(RoomReservation.ReservationStatus.valueOf(request.getStatus()));
        if (request.getNotes() != null) reservation.setNotes(request.getNotes());
        
        // Recalculer le prix si nécessaire
        if (request.getStartTime() != null || request.getEndTime() != null) {
            reservation.setTotalPriceCents(reservation.calculateTotalPrice());
        }
        
        reservation = reservationRepository.save(reservation);
        return convertReservationToDto(reservation);
    }
    
    public List<RoomReservationDto> getUserReservations(User user) {
        List<RoomReservation> reservations = reservationRepository.findByUser(user);
        
        return reservations.stream()
                .map(this::convertReservationToDto)
                .collect(Collectors.toList());
    }
    
    public List<RoomReservationDto> getRoomReservations(Long roomId) {
        List<RoomReservation> reservations = reservationRepository.findByRoomId(roomId);
        
        return reservations.stream()
                .map(this::convertReservationToDto)
                .collect(Collectors.toList());
    }
    
    public List<RoomReservationDto> getRestaurantReservations(Long restaurantId) {
        List<RoomReservation> reservations = reservationRepository.findActiveReservationsByRestaurant(restaurantId);
        
        return reservations.stream()
                .map(this::convertReservationToDto)
                .collect(Collectors.toList());
    }
    
    public RoomReservationDto getReservationById(Long reservationId) {
        RoomReservation reservation = reservationRepository.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
        
        return convertReservationToDto(reservation);
    }
    
    public void cancelReservation(User user, Long reservationId) {
        RoomReservation reservation = reservationRepository.findById(reservationId)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
        
        // Vérifier que l'utilisateur est propriétaire de la réservation ou est admin
        if (!reservation.getUser().getId().equals(user.getId()) && !user.getRole().name().equals("ADMIN")) {
            throw new RuntimeException("Unauthorized access to reservation");
        }
        
        reservation.setStatus(RoomReservation.ReservationStatus.CANCELLED);
        reservationRepository.save(reservation);
    }
    
    // === VÉRIFICATION DE DISPONIBILITÉ ===
    
    public List<RoomAvailabilityDto> checkRoomAvailability(Long roomId, LocalDateTime startTime, LocalDateTime endTime) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new RuntimeException("Room not found"));
        
        List<RoomReservation> conflicts = reservationRepository.findConflictingReservations(roomId, startTime, endTime);
        
        RoomAvailabilityDto availability = RoomAvailabilityDto.builder()
                .roomId(roomId)
                .roomName(room.getName())
                .startTime(startTime)
                .endTime(endTime)
                .available(conflicts.isEmpty() && room.getStatus() == Room.RoomStatus.AVAILABLE)
                .reason(conflicts.isEmpty() ? null : "Room has conflicting reservations")
                .build();
        
        return List.of(availability);
    }
    
    // === CONVERSION DTO ===
    
    private RoomDto convertRoomToDto(Room room) {
        return RoomDto.builder()
                .id(room.getId())
                .restaurantId(room.getRestaurant().getId())
                .restaurantName(room.getRestaurant().getName())
                .name(room.getName())
                .description(room.getDescription())
                .capacity(room.getCapacity())
                .hourlyRateCents(room.getHourlyRateCents())
                .hasWifi(room.getHasWifi())
                .hasPrinter(room.getHasPrinter())
                .hasProjector(room.getHasProjector())
                .hasWhiteboard(room.getHasWhiteboard())
                .status(room.getStatus().name())
                .createdAt(room.getCreatedAt())
                .updatedAt(room.getUpdatedAt())
                .build();
    }
    
    private RoomReservationDto convertReservationToDto(RoomReservation reservation) {
        return RoomReservationDto.builder()
                .id(reservation.getId())
                .roomId(reservation.getRoom().getId())
                .roomName(reservation.getRoom().getName())
                .userId(reservation.getUser().getId())
                .userName(reservation.getUser().getFullName())
                .reservationDate(reservation.getReservationDate())
                .startTime(reservation.getStartTime())
                .endTime(reservation.getEndTime())
                .purpose(reservation.getPurpose())
                .attendeesCount(reservation.getAttendeesCount())
                .specialRequirements(reservation.getSpecialRequirements())
                .status(reservation.getStatus().name())
                .totalPriceCents(reservation.getTotalPriceCents())
                .createdAt(reservation.getCreatedAt())
                .updatedAt(reservation.getUpdatedAt())
                .notes(reservation.getNotes())
                .build();
    }
}
