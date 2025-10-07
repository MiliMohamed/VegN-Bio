import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

class MenuProvider with ChangeNotifier {
  final MenuService _menuService = MenuService();
  
  List<MenuItem> _menuItems = [];
  List<MenuItem> _filteredItems = [];
  List<String> _categories = [];
  String _selectedCategory = 'Tous';
  String _searchQuery = '';
  List<String> _excludedAllergens = [];
  bool _showVeganOnly = false;
  bool _showVegetarianOnly = false;
  bool _showGlutenFreeOnly = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<MenuItem> get menuItems => _menuItems;
  List<MenuItem> get filteredItems => _filteredItems;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  List<String> get excludedAllergens => _excludedAllergens;
  bool get showVeganOnly => _showVeganOnly;
  bool get showVegetarianOnly => _showVegetarianOnly;
  bool get showGlutenFreeOnly => _showGlutenFreeOnly;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMenuItems() async {
    _setLoading(true);
    _clearError();

    try {
      _menuItems = await _menuService.getMenuItems();
      _categories = _menuService.getAllCategories();
      _categories.insert(0, 'Tous');
      _applyFilters();
    } catch (e) {
      _setError('Erreur lors du chargement du menu: $e');
    } finally {
      _setLoading(false);
    }
  }

  void searchMenuItems(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void toggleAllergen(String allergen) {
    if (_excludedAllergens.contains(allergen)) {
      _excludedAllergens.remove(allergen);
    } else {
      _excludedAllergens.add(allergen);
    }
    _applyFilters();
  }

  void setVeganOnly(bool value) {
    _showVeganOnly = value;
    if (value) _showVegetarianOnly = false;
    _applyFilters();
  }

  void setVegetarianOnly(bool value) {
    _showVegetarianOnly = value;
    if (value) _showVeganOnly = false;
    _applyFilters();
  }

  void setGlutenFreeOnly(bool value) {
    _showGlutenFreeOnly = value;
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = 'Tous';
    _excludedAllergens.clear();
    _showVeganOnly = false;
    _showVegetarianOnly = false;
    _showGlutenFreeOnly = false;
    _applyFilters();
  }

  void _applyFilters() {
    List<MenuItem> filtered = List.from(_menuItems);

    // Filtre par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Filtre par recherche
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(queryLower) ||
               item.description.toLowerCase().contains(queryLower) ||
               item.ingredients.any((ingredient) => 
                   ingredient.toLowerCase().contains(queryLower));
      }).toList();
    }

    // Filtre par allergènes
    if (_excludedAllergens.isNotEmpty) {
      filtered = filtered.where((item) {
        return !item.allergens.any((allergen) => 
            _excludedAllergens.contains(allergen.toLowerCase()));
      }).toList();
    }

    // Filtre végan
    if (_showVeganOnly) {
      filtered = filtered.where((item) => item.isVegan).toList();
    }

    // Filtre végétarien
    if (_showVegetarianOnly) {
      filtered = filtered.where((item) => item.isVegetarian).toList();
    }

    // Filtre sans gluten
    if (_showGlutenFreeOnly) {
      filtered = filtered.where((item) => item.isGlutenFree).toList();
    }

    _filteredItems = filtered;
    notifyListeners();
  }

  List<String> getAllAllergens() {
    final allergens = <String>{};
    for (final item in _menuItems) {
      allergens.addAll(item.allergens);
    }
    return allergens.toList()..sort();
  }

  List<MenuItem> getRecommendedItems() {
    // Retourner les items les plus populaires ou recommandés
    final recommended = _menuItems.where((item) => 
        item.category == 'Plats' || item.category == 'Salades').toList();
    
    // Trier par nombre d'ingrédients (plus d'ingrédients = plus complet)
    recommended.sort((a, b) => b.ingredients.length.compareTo(a.ingredients.length));
    
    return recommended.take(3).toList();
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

  Future<void> refresh() async {
    _menuService.clearCache();
    await loadMenuItems();
  }
}
