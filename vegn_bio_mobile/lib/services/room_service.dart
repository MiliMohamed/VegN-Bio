import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';
import 'api_service.dart';

class RoomService {
  final ApiService _apiService = ApiService();

  Future<List<Room>> getRoomsByRestaurant(int restaurantId) async {
    try {
      final response = await _apiService.get('/api/v1/rooms/restaurant/$restaurantId');
      return (response as List).map((json) => Room.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des salles: $e');
    }
  }

  Future<List<Room>> getAvailableRooms(int restaurantId, {int? minCapacity}) async {
    try {
      final params = <String, String>{};
      if (minCapacity != null) {
        params['minCapacity'] = minCapacity.toString();
      }
      
      final response = await _apiService.get('/api/v1/rooms/restaurant/$restaurantId/available', params: params);
      return (response as List).map((json) => Room.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des salles disponibles: $e');
    }
  }

  Future<Room> getRoomById(int roomId) async {
    try {
      final response = await _apiService.get('/api/v1/rooms/$roomId');
      return Room.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors du chargement de la salle: $e');
    }
  }

  Future<RoomReservation> createReservation(CreateReservationRequest request) async {
    try {
      final response = await _apiService.post('/api/v1/rooms/${request.roomId}/reservations', request.toJson());
      return RoomReservation.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la création de la réservation: $e');
    }
  }

  Future<RoomReservation> updateReservation(int reservationId, UpdateReservationRequest request) async {
    try {
      final response = await _apiService.put('/api/v1/rooms/reservations/$reservationId', request.toJson());
      return RoomReservation.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la réservation: $e');
    }
  }

  Future<List<RoomReservation>> getUserReservations() async {
    try {
      final response = await _apiService.get('/api/v1/rooms/reservations/my');
      return (response as List).map((json) => RoomReservation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des réservations: $e');
    }
  }

  Future<List<RoomReservation>> getRoomReservations(int roomId) async {
    try {
      final response = await _apiService.get('/api/v1/rooms/$roomId/reservations');
      return (response as List).map((json) => RoomReservation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erreur lors du chargement des réservations de la salle: $e');
    }
  }

  Future<RoomReservation> getReservationById(int reservationId) async {
    try {
      final response = await _apiService.get('/api/v1/rooms/reservations/$reservationId');
      return RoomReservation.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors du chargement de la réservation: $e');
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    try {
      await _apiService.post('/api/v1/rooms/reservations/$reservationId/cancel', {});
    } catch (e) {
      throw Exception('Erreur lors de l\'annulation de la réservation: $e');
    }
  }

  Future<bool> checkRoomAvailability(int roomId, DateTime startTime, DateTime endTime) async {
    try {
      final params = {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      };
      
      final response = await _apiService.get('/api/v1/rooms/$roomId/availability', params: params);
      return response.isNotEmpty && response[0]['available'] == true;
    } catch (e) {
      throw Exception('Erreur lors de la vérification de disponibilité: $e');
    }
  }
}
