import 'package:ecommerce_app/database/db_helper.dart';
import 'package:flutter/material.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _favoriteProducts = [];
  bool _isFavorite = false;

  List<Map<String, dynamic>> get favoriteProducts => _favoriteProducts;
  bool get isFavorite => _isFavorite;

  Future<void> loadFavoriteProducts(String username) async {
    _favoriteProducts = await _dbHelper.getFavoriteProduct(username);
    notifyListeners();
  }

  Future<void> toggleFavorite(
      String username, Map<String, dynamic> product) async {
    if (_isFavorite) {
      await _dbHelper.removeFavoriteProduct(username, product['title']);
    } else {
      await _dbHelper.insertFavoriteProduct(
          username,
          product['title'] as String,
          product['description'] as String,
          product['category'] as String,
          product['image'] as String,
          product['price'] as double,
          product['rating_rate'] as double,
          product['rating_count'] as int);
    }
    _isFavorite = !_isFavorite;
    await loadFavoriteProducts(username); // Reload the favorites
  }

  Future<void> checkIfFavorite(String username, String productName) async {
    _isFavorite = await _dbHelper.isFavorite(username, productName);
    notifyListeners();
  }
}
