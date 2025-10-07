import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../models/allergen.dart';
import '../services/restaurant_service.dart';

class RestaurantProvider with ChangeNotifier {
  final RestaurantService _restaurantService = RestaurantService();
  
  List<Restaurant> _restaurants = [];
  List<Allergen> _allergens = [];
  String _searchQuery = '';
  String _selectedCity = 'Toutes';
  bool _isLoading = false;
  bool _isConnected = false;
  String? _error;

  // Getters
  List<Restaurant> get restaurants => _restaurants;
  List<Allergen> get allergens => _allergens;
  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get error => _error;

  /// Charge tous les restaurants
  Future<void> loadRestaurants() async {
    _setLoading(true);
    _clearError();

    try {
      _restaurants = await _restaurantService.getRestaurants();
      _isConnected = await _restaurantService.checkConnection();
    } catch (e) {
      _setError('Erreur lors du chargement des restaurants: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Charge tous les allergènes
  Future<void> loadAllergens() async {
    _setLoading(true);
    _clearError();

    try {
      _allergens = await _restaurantService.getAllergens();
    } catch (e) {
      _setError('Erreur lors du chargement des allergènes: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Recherche des restaurants
  void searchRestaurants(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Filtre par ville
  void setCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  /// Efface les filtres
  void clearFilters() {
    _searchQuery = '';
    _selectedCity = 'Toutes';
    notifyListeners();
  }

  /// Obtient la liste des restaurants filtrés
  List<Restaurant> get filteredRestaurants {
    List<Restaurant> filtered = List.from(_restaurants);

    // Filtre par ville
    if (_selectedCity != 'Toutes') {
      filtered = filtered.where((restaurant) => 
          restaurant.city == _selectedCity).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      filtered = filtered.where((restaurant) {
        return restaurant.name.toLowerCase().contains(queryLower) ||
               restaurant.city.toLowerCase().contains(queryLower) ||
               restaurant.address.toLowerCase().contains(queryLower);
      }).toList();
    }

    return filtered;
  }

  /// Obtient la liste de toutes les villes
  List<String> get availableCities {
    final cities = <String>{'Toutes'};
    for (final restaurant in _restaurants) {
      cities.add(restaurant.city);
    }
    return cities.toList()..sort();
  }

  /// Recherche un restaurant par ID
  Restaurant? getRestaurantById(int id) {
    try {
      return _restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Recherche un allergène par code
  Allergen? getAllergenByCode(String code) {
    try {
      return _allergens.firstWhere((allergen) => allergen.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Obtient les restaurants populaires (pour les recommandations)
  List<Restaurant> get recommendedRestaurants {
    // Retourner les premiers restaurants comme recommandés
    return _restaurants.take(3).toList();
  }

  /// Vérifie la connexion au backend
  Future<void> checkConnection() async {
    _isConnected = await _restaurantService.checkConnection();
    notifyListeners();
  }

  /// Actualise les données
  Future<void> refresh() async {
    _restaurantService.clearCache();
    await loadRestaurants();
    await loadAllergens();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
