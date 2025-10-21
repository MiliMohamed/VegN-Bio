class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final int totalItems;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalItems,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ?? [],
      totalItems: json['totalItems'] ?? 0,
      totalPrice: (json['totalPriceCents'] ?? 0) / 100.0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalItems': totalItems,
      'totalPriceCents': (totalPrice * 100).round(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status,
    };
  }
}

class CartItem {
  final int id;
  final int menuItemId;
  final String menuItemName;
  final String menuItemDescription;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? specialInstructions;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.menuItemDescription,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.specialInstructions,
    required this.addedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      menuItemId: json['menuItemId'],
      menuItemName: json['menuItemName'] ?? 'Article',
      menuItemDescription: json['menuItemDescription'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPriceCents'] ?? 0) / 100.0,
      totalPrice: (json['totalPriceCents'] ?? 0) / 100.0,
      specialInstructions: json['specialInstructions'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'menuItemName': menuItemName,
      'menuItemDescription': menuItemDescription,
      'quantity': quantity,
      'unitPriceCents': (unitPrice * 100).round(),
      'totalPriceCents': (totalPrice * 100).round(),
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

class AddToCartRequest {
  final int menuItemId;
  final int quantity;
  final String? specialInstructions;

  AddToCartRequest({
    required this.menuItemId,
    required this.quantity,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }
}

class UpdateCartItemRequest {
  final int quantity;
  final String? specialInstructions;

  UpdateCartItemRequest({
    required this.quantity,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }
}
