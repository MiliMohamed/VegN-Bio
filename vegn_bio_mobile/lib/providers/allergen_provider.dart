import 'package:flutter/material.dart';
import '../models/allergen.dart';
import '../services/allergen_service.dart';

class AllergenProvider extends ChangeNotifier {
  final AllergenService _allergenService = AllergenService();
  
  List<Allergen> _allergens = [];
  List<String> _selectedAllergens = [];
  bool _isLoading = false;
  String? _error;

  List<Allergen> get allergens => _allergens;
  List<String> get selectedAllergens => _selectedAllergens;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAllergens() async {
    _setLoading(true);
    try {
      _allergens = await _allergenService.getAllAllergens();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void toggleAllergen(String allergenCode) {
    if (_selectedAllergens.contains(allergenCode)) {
      _selectedAllergens.remove(allergenCode);
    } else {
      _selectedAllergens.add(allergenCode);
    }
    notifyListeners();
  }

  void clearSelectedAllergens() {
    _selectedAllergens.clear();
    notifyListeners();
  }

  bool isAllergenSelected(String allergenCode) {
    return _selectedAllergens.contains(allergenCode);
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
