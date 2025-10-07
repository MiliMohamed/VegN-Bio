class Restaurant {
  final int id;
  final String name;
  final String code;
  final String address;
  final String city;
  final String phone;
  final String email;

  Restaurant({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    required this.city,
    required this.phone,
    required this.email,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
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
    };
  }

  String get fullAddress => '$address, $city';
  
  String get displayInfo => '$name - $city';
  
  @override
  String toString() => 'Restaurant(id: $id, name: $name, city: $city)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
