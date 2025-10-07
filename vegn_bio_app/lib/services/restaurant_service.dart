import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant.dart';
import '../models/allergen.dart';

class RestaurantService {
  static const String _baseUrl = 'http://localhost:8080/api/v1'; // URL de votre backend Spring Boot
  static final RestaurantService _instance = RestaurantService._internal();
  factory RestaurantService() => _instance;
  RestaurantService._internal();

  List<Restaurant> _cachedRestaurants = [];
  List<Allergen> _cachedAllergens = [];
  bool _isRestaurantsLoaded = false;
  bool _isAllergensLoaded = false;

  // Données de démonstration pour le développement
  static const List<Map<String, dynamic>> _demoRestaurants = [
    {
      'id': 1,
      'name': 'Restaurant Bio Paris',
      'code': 'RBP001',
      'address': '123 Rue de la Paix',
      'city': 'Paris',
      'phone': '+33 1 23 45 67 89',
      'email': 'contact@restaurantbioparis.fr'
    },
    {
      'id': 2,
      'name': 'Le Jardin Vert',
      'code': 'LJV002',
      'address': '45 Avenue des Champs',
      'city': 'Lyon',
      'phone': '+33 4 56 78 90 12',
      'email': 'info@lejardinvert.fr'
    },
    {
      'id': 3,
      'name': 'Vegan Corner',
      'code': 'VC003',
      'address': '78 Boulevard Saint-Germain',
      'city': 'Marseille',
      'phone': '+33 4 91 23 45 67',
      'email': 'hello@vegancorner.fr'
    },
    {
      'id': 4,
      'name': 'Nature & Go',
      'code': 'NG004',
      'address': '12 Place de la République',
      'city': 'Toulouse',
      'phone': '+33 5 61 23 45 67',
      'email': 'contact@natureandgo.fr'
    }
  ];

  static const List<Map<String, dynamic>> _demoAllergens = [
    {
      'id': 1,
      'code': 'GLUTEN',
      'label': 'Gluten'
    },
    {
      'id': 2,
      'code': 'LACTOSE',
      'label': 'Lactose'
    },
    {
      'id': 3,
      'code': 'SOJA',
      'label': 'Soja'
    },
    {
      'id': 4,
      'code': 'NOIX',
      'label': 'Fruits à coque'
    },
    {
      'id': 5,
      'code': 'OEUF',
      'label': 'Œufs'
    },
    {
      'id': 6,
      'code': 'POISSON',
      'label': 'Poisson'
    },
    {
      'id': 7,
      'code': 'CRUSTACES',
      'label': 'Crustacés'
    },
    {
      'id': 8,
      'code': 'MOLLUSQUES',
      'label': 'Mollusques'
    }
  ];

  /// Récupère la liste de tous les restaurants
  Future<List<Restaurant>> getRestaurants() async {
    if (_isRestaurantsLoaded) {
      return _cachedRestaurants;
    }

    try {
      // En mode développement, utiliser les données de démonstration
      if (true) { // TODO: Remplacer par une vérification d'environnement
        _cachedRestaurants = _demoRestaurants
            .map((restaurant) => Restaurant.fromJson(restaurant))
            .toList();
        _isRestaurantsLoaded = true;
        return _cachedRestaurants;
      }

      // Code pour la production
      final response = await http.get(
        Uri.parse('$_baseUrl/restaurants'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedRestaurants = data
            .map((restaurant) => Restaurant.fromJson(restaurant))
            .toList();
        _isRestaurantsLoaded = true;
        return _cachedRestaurants;
      } else {
        throw Exception('Erreur lors du chargement des restaurants: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback vers les données de démonstration en cas d'erreur
      _cachedRestaurants = _demoRestaurants
          .map((restaurant) => Restaurant.fromJson(restaurant))
          .toList();
      _isRestaurantsLoaded = true;
      return _cachedRestaurants;
    }
  }

  /// Récupère un restaurant par son ID
  Future<Restaurant?> getRestaurantById(int id) async {
    try {
      // En mode développement
      if (true) {
        final restaurants = await getRestaurants();
        try {
          return restaurants.firstWhere((restaurant) => restaurant.id == id);
        } catch (e) {
          return null;
        }
      }

      // Code pour la production
      final response = await http.get(
        Uri.parse('$_baseUrl/restaurants/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Restaurant.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erreur lors de la récupération du restaurant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du restaurant: $e');
    }
  }

  /// Récupère la liste de tous les allergènes
  Future<List<Allergen>> getAllergens() async {
    if (_isAllergensLoaded) {
      return _cachedAllergens;
    }

    try {
      // En mode développement, utiliser les données de démonstration
      if (true) { // TODO: Remplacer par une vérification d'environnement
        _cachedAllergens = _demoAllergens
            .map((allergen) => Allergen.fromJson(allergen))
            .toList();
        _isAllergensLoaded = true;
        return _cachedAllergens;
      }

      // Code pour la production
      final response = await http.get(
        Uri.parse('$_baseUrl/allergens'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedAllergens = data
            .map((allergen) => Allergen.fromJson(allergen))
            .toList();
        _isAllergensLoaded = true;
        return _cachedAllergens;
      } else {
        throw Exception('Erreur lors du chargement des allergènes: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback vers les données de démonstration en cas d'erreur
      _cachedAllergens = _demoAllergens
          .map((allergen) => Allergen.fromJson(allergen))
          .toList();
      _isAllergensLoaded = true;
      return _cachedAllergens;
    }
  }

  /// Récupère un allergène par son code
  Future<Allergen?> getAllergenByCode(String code) async {
    try {
      // En mode développement
      if (true) {
        final allergens = await getAllergens();
        try {
          return allergens.firstWhere((allergen) => allergen.code == code);
        } catch (e) {
          return null;
        }
      }

      // Code pour la production
      final response = await http.get(
        Uri.parse('$_baseUrl/allergens/$code'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Allergen.fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erreur lors de la récupération de l\'allergène: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'allergène: $e');
    }
  }

  /// Recherche des restaurants par nom ou ville
  Future<List<Restaurant>> searchRestaurants(String query) async {
    final allRestaurants = await getRestaurants();
    final queryLower = query.toLowerCase();
    
    return allRestaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(queryLower) ||
             restaurant.city.toLowerCase().contains(queryLower) ||
             restaurant.address.toLowerCase().contains(queryLower);
    }).toList();
  }

  /// Filtre les restaurants par ville
  Future<List<Restaurant>> getRestaurantsByCity(String city) async {
    final allRestaurants = await getRestaurants();
    return allRestaurants.where((restaurant) => 
        restaurant.city.toLowerCase() == city.toLowerCase()).toList();
  }

  /// Obtient la liste de toutes les villes disponibles
  List<String> getAllCities() {
    final cities = <String>{};
    for (final restaurant in _cachedRestaurants) {
      cities.add(restaurant.city);
    }
    return cities.toList()..sort();
  }

  /// Efface le cache
  void clearCache() {
    _cachedRestaurants.clear();
    _cachedAllergens.clear();
    _isRestaurantsLoaded = false;
    _isAllergensLoaded = false;
  }

  /// Vérifie si le service est connecté au backend
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/restaurants'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
