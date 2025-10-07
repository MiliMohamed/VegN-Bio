class Restaurant {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String description;
  final String? imageUrl;
  final bool isActive;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.description,
    this.imageUrl,
    required this.isActive,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}
