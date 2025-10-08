class Menu {
  final int id;
  final String title;
  final DateTime activeFrom;
  final DateTime activeTo;
  final List<MenuItem> menuItems;

  Menu({
    required this.id,
    required this.title,
    required this.activeFrom,
    required this.activeTo,
    required this.menuItems,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      title: json['title'] ?? 'Menu',
      activeFrom: DateTime.parse(json['activeFrom']),
      activeTo: DateTime.parse(json['activeTo']),
      menuItems: (json['menuItems'] as List<dynamic>?)
          ?.map((item) => MenuItem.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'activeFrom': activeFrom.toIso8601String(),
      'activeTo': activeTo.toIso8601String(),
      'menuItems': menuItems.map((item) => item.toJson()).toList(),
    };
  }
}

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final bool isVegan;
  final List<Allergen> allergens;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.isVegan,
    required this.allergens,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'] ?? 'Article',
      description: json['description'] ?? '',
      price: (json['priceCents'] ?? 0) / 100.0, // Convertir centimes en euros
      isVegan: json['isVegan'] ?? false,
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((allergen) => Allergen.fromJson(allergen))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'priceCents': (price * 100).round(),
      'isVegan': isVegan,
      'allergens': allergens.map((allergen) => allergen.toJson()).toList(),
    };
  }
}

class Allergen {
  final int id;
  final String code;
  final String label;

  Allergen({
    required this.id,
    required this.code,
    required this.label,
  });

  factory Allergen.fromJson(Map<String, dynamic> json) {
    return Allergen(
      id: json['id'],
      code: json['code'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'label': label,
    };
  }
}
