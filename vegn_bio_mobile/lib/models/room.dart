class Room {
  final int id;
  final int restaurantId;
  final String restaurantName;
  final String name;
  final String description;
  final int capacity;
  final double hourlyRate;
  final bool hasWifi;
  final bool hasPrinter;
  final bool hasProjector;
  final bool hasWhiteboard;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.name,
    required this.description,
    required this.capacity,
    required this.hourlyRate,
    required this.hasWifi,
    required this.hasPrinter,
    required this.hasProjector,
    required this.hasWhiteboard,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'] ?? 'Restaurant',
      name: json['name'] ?? 'Salle',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 1,
      hourlyRate: (json['hourlyRateCents'] ?? 0) / 100.0,
      hasWifi: json['hasWifi'] ?? false,
      hasPrinter: json['hasPrinter'] ?? false,
      hasProjector: json['hasProjector'] ?? false,
      hasWhiteboard: json['hasWhiteboard'] ?? false,
      status: json['status'] ?? 'AVAILABLE',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'name': name,
      'description': description,
      'capacity': capacity,
      'hourlyRateCents': (hourlyRate * 100).round(),
      'hasWifi': hasWifi,
      'hasPrinter': hasPrinter,
      'hasProjector': hasProjector,
      'hasWhiteboard': hasWhiteboard,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isAvailable => status == 'AVAILABLE';
}

class RoomReservation {
  final int id;
  final int roomId;
  final String roomName;
  final int userId;
  final String userName;
  final DateTime reservationDate;
  final DateTime startTime;
  final DateTime endTime;
  final String purpose;
  final int attendeesCount;
  final String? specialRequirements;
  final String status;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  RoomReservation({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.userId,
    required this.userName,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.purpose,
    required this.attendeesCount,
    this.specialRequirements,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory RoomReservation.fromJson(Map<String, dynamic> json) {
    return RoomReservation(
      id: json['id'],
      roomId: json['roomId'],
      roomName: json['roomName'] ?? 'Salle',
      userId: json['userId'],
      userName: json['userName'] ?? 'Utilisateur',
      reservationDate: DateTime.parse(json['reservationDate']),
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      purpose: json['purpose'] ?? '',
      attendeesCount: json['attendeesCount'] ?? 1,
      specialRequirements: json['specialRequirements'],
      status: json['status'] ?? 'PENDING',
      totalPrice: (json['totalPriceCents'] ?? 0) / 100.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'userId': userId,
      'userName': userName,
      'reservationDate': reservationDate.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'purpose': purpose,
      'attendeesCount': attendeesCount,
      'specialRequirements': specialRequirements,
      'status': status,
      'totalPriceCents': (totalPrice * 100).round(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
    };
  }

  Duration get duration => endTime.difference(startTime);
  int get durationInHours => duration.inHours;
}

class CreateReservationRequest {
  final int roomId;
  final DateTime startTime;
  final DateTime endTime;
  final String purpose;
  final int attendeesCount;
  final String? specialRequirements;
  final String? notes;

  CreateReservationRequest({
    required this.roomId,
    required this.startTime,
    required this.endTime,
    required this.purpose,
    required this.attendeesCount,
    this.specialRequirements,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'purpose': purpose,
      'attendeesCount': attendeesCount,
      'specialRequirements': specialRequirements,
      'notes': notes,
    };
  }
}

class UpdateReservationRequest {
  final DateTime? startTime;
  final DateTime? endTime;
  final String? purpose;
  final int? attendeesCount;
  final String? specialRequirements;
  final String? status;
  final String? notes;

  UpdateReservationRequest({
    this.startTime,
    this.endTime,
    this.purpose,
    this.attendeesCount,
    this.specialRequirements,
    this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'purpose': purpose,
      'attendeesCount': attendeesCount,
      'specialRequirements': specialRequirements,
      'status': status,
      'notes': notes,
    };
  }
}
