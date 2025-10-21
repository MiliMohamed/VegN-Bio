import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService = ApiService();

  Future<Cart> getCart() async {
    try {
      final response = await _apiService.get('/api/v1/cart');
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors du chargement du panier: $e');
    }
  }

  Future<Cart> addToCart(AddToCartRequest request) async {
    try {
      final response = await _apiService.post('/api/v1/cart/items', request.toJson());
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout au panier: $e');
    }
  }

  Future<Cart> updateCartItem(int cartItemId, UpdateCartItemRequest request) async {
    try {
      final response = await _apiService.put('/api/v1/cart/items/$cartItemId', request.toJson());
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour: $e');
    }
  }

  Future<Cart> removeFromCart(int cartItemId) async {
    try {
      final response = await _apiService.delete('/api/v1/cart/items/$cartItemId');
      return Cart.fromJson(response);
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiService.delete('/api/v1/cart');
    } catch (e) {
      throw Exception('Erreur lors du vidage du panier: $e');
    }
  }

  Future<void> abandonCart() async {
    try {
      await _apiService.post('/api/v1/cart/abandon', {});
    } catch (e) {
      throw Exception('Erreur lors de l\'abandon du panier: $e');
    }
  }
}
