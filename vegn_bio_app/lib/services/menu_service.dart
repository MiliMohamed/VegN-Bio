import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';

class MenuService {
  static const String _baseUrl = 'https://api.vegnbio.com'; // URL fictive
  static final MenuService _instance = MenuService._internal();
  factory MenuService() => _instance;
  MenuService._internal();

  List<MenuItem> _cachedMenuItems = [];
  bool _isLoaded = false;

  // Données de démonstration pour le développement
  static const List<Map<String, dynamic>> _demoMenuItems = [
    {
      'id': '1',
      'name': 'Salade Quinoa Bio',
      'description': 'Quinoa bio, légumes de saison, vinaigrette aux herbes',
      'price': 12.50,
      'category': 'Salades',
      'allergens': ['gluten'],
      'imageUrl': 'assets/images/placeholder.txt',
      'isVegan': true,
      'isVegetarian': true,
      'isGlutenFree': false,
      'ingredients': ['Quinoa bio', 'Tomates cerises', 'Concombre', 'Herbes fraîches'],
      'calories': 280,
      'preparationTime': '10 min'
    },
    {
      'id': '2',
      'name': 'Burger Végétarien',
      'description': 'Steak végétal, salade, tomate, sauce spéciale',
      'price': 15.90,
      'category': 'Plats',
      'allergens': ['gluten', 'soja'],
      'imageUrl': 'assets/images/placeholder.txt',
      'isVegan': false,
      'isVegetarian': true,
      'isGlutenFree': false,
      'ingredients': ['Pain complet', 'Steak végétal', 'Salade', 'Tomate', 'Sauce'],
      'calories': 450,
      'preparationTime': '15 min'
    },
    {
      'id': '3',
      'name': 'Smoothie Vert Détox',
      'description': 'Épinards, pomme, banane, gingembre, eau de coco',
      'price': 7.50,
      'category': 'Boissons',
      'allergens': [],
      'imageUrl': 'assets/images/placeholder.txt',
      'isVegan': true,
      'isVegetarian': true,
      'isGlutenFree': true,
      'ingredients': ['Épinards bio', 'Pomme', 'Banane', 'Gingembre', 'Eau de coco'],
      'calories': 120,
      'preparationTime': '5 min'
    },
    {
      'id': '4',
      'name': 'Tarte aux Légumes',
      'description': 'Pâte brisée, courgettes, aubergines, fromage de chèvre',
      'price': 14.00,
      'category': 'Plats',
      'allergens': ['gluten', 'lactose'],
      'imageUrl': 'assets/images/placeholder.txt',
      'isVegan': false,
      'isVegetarian': true,
      'isGlutenFree': false,
      'ingredients': ['Pâte brisée', 'Courgettes', 'Aubergines', 'Fromage de chèvre', 'Herbes'],
      'calories': 380,
      'preparationTime': '25 min'
    },
    {
      'id': '5',
      'name': 'Curry de Légumes',
      'description': 'Légumes de saison, lait de coco, épices indiennes, riz basmati',
      'price': 16.50,
      'category': 'Plats',
      'allergens': [],
      'imageUrl': 'assets/images/placeholder.txt',
      'isVegan': true,
      'isVegetarian': true,
      'isGlutenFree': true,
      'ingredients': ['Légumes de saison', 'Lait de coco', 'Épices', 'Riz basmati'],
      'calories': 420,
      'preparationTime': '20 min'
    }
  ];

  Future<List<MenuItem>> getMenuItems() async {
    if (_isLoaded) {
      return _cachedMenuItems;
    }

    try {
      // En mode développement, utiliser les données de démonstration
      if (true) { // TODO: Remplacer par une vérification d'environnement
        _cachedMenuItems = _demoMenuItems
            .map((item) => MenuItem.fromJson(item))
            .toList();
        _isLoaded = true;
        return _cachedMenuItems;
      }

      // Code pour la production
      final response = await http.get(
        Uri.parse('$_baseUrl/menu'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedMenuItems = data
            .map((item) => MenuItem.fromJson(item))
            .toList();
        _isLoaded = true;
        return _cachedMenuItems;
      } else {
        throw Exception('Erreur lors du chargement du menu: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback vers les données de démonstration en cas d'erreur
      _cachedMenuItems = _demoMenuItems
          .map((item) => MenuItem.fromJson(item))
          .toList();
      _isLoaded = true;
      return _cachedMenuItems;
    }
  }

  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    final allItems = await getMenuItems();
    return allItems.where((item) => item.category == category).toList();
  }

  Future<List<MenuItem>> searchMenuItems(String query) async {
    final allItems = await getMenuItems();
    final queryLower = query.toLowerCase();
    
    return allItems.where((item) {
      return item.name.toLowerCase().contains(queryLower) ||
             item.description.toLowerCase().contains(queryLower) ||
             item.ingredients.any((ingredient) => 
                 ingredient.toLowerCase().contains(queryLower));
    }).toList();
  }

  Future<List<MenuItem>> filterByAllergens(List<String> excludedAllergens) async {
    final allItems = await getMenuItems();
    
    return allItems.where((item) {
      return !item.allergens.any((allergen) => 
          excludedAllergens.contains(allergen.toLowerCase()));
    }).toList();
  }

  Future<List<MenuItem>> getVeganItems() async {
    final allItems = await getMenuItems();
    return allItems.where((item) => item.isVegan).toList();
  }

  Future<List<MenuItem>> getVegetarianItems() async {
    final allItems = await getMenuItems();
    return allItems.where((item) => item.isVegetarian).toList();
  }

  Future<List<MenuItem>> getGlutenFreeItems() async {
    final allItems = await getMenuItems();
    return allItems.where((item) => item.isGlutenFree).toList();
  }

  List<String> getAllCategories() {
    final categories = <String>{};
    for (final item in _cachedMenuItems) {
      categories.add(item.category);
    }
    return categories.toList()..sort();
  }

  void clearCache() {
    _cachedMenuItems.clear();
    _isLoaded = false;
  }
}
