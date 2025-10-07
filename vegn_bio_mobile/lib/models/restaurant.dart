class Restaurant {
  final int id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String phone;
  final String email;
  
  // Nouvelles informations détaillées
  final bool? wifiAvailable;
  final int? meetingRoomsCount;
  final int? restaurantCapacity;
  final bool? printerAvailable;
  final bool? memberTrays;
  final bool? deliveryAvailable;
  final String? specialEvents;
  final String? mondayThursdayHours;
  final String? fridayHours;
  final String? saturdayHours;
  final String? sundayHours;

  Restaurant({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
    this.wifiAvailable,
    this.meetingRoomsCount,
    this.restaurantCapacity,
    this.printerAvailable,
    this.memberTrays,
    this.deliveryAvailable,
    this.specialEvents,
    this.mondayThursdayHours,
    this.fridayHours,
    this.saturdayHours,
    this.sundayHours,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      wifiAvailable: json['wifiAvailable'],
      meetingRoomsCount: json['meetingRoomsCount'],
      restaurantCapacity: json['restaurantCapacity'],
      printerAvailable: json['printerAvailable'],
      memberTrays: json['memberTrays'],
      deliveryAvailable: json['deliveryAvailable'],
      specialEvents: json['specialEvents'],
      mondayThursdayHours: json['mondayThursdayHours'],
      fridayHours: json['fridayHours'],
      saturdayHours: json['saturdayHours'],
      sundayHours: json['sundayHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'city': city,
      'phone': phone,
      'email': email,
      'wifiAvailable': wifiAvailable,
      'meetingRoomsCount': meetingRoomsCount,
      'restaurantCapacity': restaurantCapacity,
      'printerAvailable': printerAvailable,
      'memberTrays': memberTrays,
      'deliveryAvailable': deliveryAvailable,
      'specialEvents': specialEvents,
      'mondayThursdayHours': mondayThursdayHours,
      'fridayHours': fridayHours,
      'saturdayHours': saturdayHours,
      'sundayHours': sundayHours,
    };
  }
}
