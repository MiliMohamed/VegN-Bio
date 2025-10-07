class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> allergens;
  final String imageUrl;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final List<String> ingredients;
  final int calories;
  final String preparationTime;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.allergens,
    required this.imageUrl,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.ingredients,
    required this.calories,
    required this.preparationTime,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      allergens: List<String>.from(json['allergens'] as List),
      imageUrl: json['imageUrl'] as String,
      isVegan: json['isVegan'] as bool,
      isVegetarian: json['isVegetarian'] as bool,
      isGlutenFree: json['isGlutenFree'] as bool,
      ingredients: List<String>.from(json['ingredients'] as List),
      calories: json['calories'] as int,
      preparationTime: json['preparationTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'allergens': allergens,
      'imageUrl': imageUrl,
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isGlutenFree': isGlutenFree,
      'ingredients': ingredients,
      'calories': calories,
      'preparationTime': preparationTime,
    };
  }

  String get allergenWarning {
    if (allergens.isEmpty) return 'Aucun allergène connu';
    return 'Contient: ${allergens.join(', ')}';
  }

  String get dietaryInfo {
    List<String> info = [];
    if (isVegan) info.add('Végan');
    if (isVegetarian) info.add('Végétarien');
    if (isGlutenFree) info.add('Sans gluten');
    return info.isEmpty ? 'Standard' : info.join(', ');
  }
}
