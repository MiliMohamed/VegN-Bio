class Menu {
  final int id;
  final String name;
  final String description;
  final double price;
  final int restaurantId;
  final List<String> allergens;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? validFrom;
  final DateTime? validTo;

  Menu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.restaurantId,
    required this.allergens,
    required this.category,
    required this.isActive,
    required this.createdAt,
    this.validFrom,
    this.validTo,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      restaurantId: json['restaurantId'],
      allergens: List<String>.from(json['allergens'] ?? []),
      category: json['category'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      validFrom: json['validFrom'] != null ? DateTime.parse(json['validFrom']) : null,
      validTo: json['validTo'] != null ? DateTime.parse(json['validTo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'restaurantId': restaurantId,
      'allergens': allergens,
      'category': category,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'validFrom': validFrom?.toIso8601String(),
      'validTo': validTo?.toIso8601String(),
    };
  }
}
