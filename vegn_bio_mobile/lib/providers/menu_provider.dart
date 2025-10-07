import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class MenuProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Menu> _menus = [];
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _error;

  List<Menu> get menus => _menus;
  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRestaurants() async {
    _setLoading(true);
    try {
      _restaurants = await _apiService.getRestaurants();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadMenusByRestaurant(int restaurantId) async {
    _setLoading(true);
    try {
      _menus = await _apiService.getMenusByRestaurant(restaurantId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadActiveMenusByRestaurant(int restaurantId, {DateTime? date}) async {
    _setLoading(true);
    try {
      _menus = await _apiService.getActiveMenusByRestaurant(restaurantId, date: date);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchMenusByAllergens(List<String> allergens) async {
    _setLoading(true);
    try {
      _menus = await _apiService.searchMenusByAllergens(allergens);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
