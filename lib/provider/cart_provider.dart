import 'package:ecommerce_app/database/db_helper.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _cartProducts = [];
  bool _isCarted = false;

  List<Map<String, dynamic>> get cartProducts => _cartProducts;
  bool get isCarted => _isCarted;

  Future<void> loadCartProducts(String username) async {
    _cartProducts = await _dbHelper.getCartProduct(username);
    notifyListeners();
  }

  Future<void> addToCart(String username, Map<String, dynamic> product) async {
    bool isInCart = await _dbHelper.isInCart(username, product['title']);
    if (!isInCart) {
      await _dbHelper.insertCartProduct(
          username,
          product['title'] as String,
          product['description'] as String,
          product['category'] as String,
          product['image'] as String,
          product['price'] as double,
          product['rating_rate'] as double,
          product['rating_count'] as int);
      await loadCartProducts(username); // Reload the cart products
    }
  }

  Future<bool> isProductInCart(String username, String productName) async {
    return await _dbHelper.isInCart(username, productName);
  }

  Future<void> updateCartProductQuantity(
      String username, String productName, int quantity) async {
    await _dbHelper.updateCartProductQuantity(username, productName, quantity);
    await loadCartProducts(username); // Reload the cart products
  }

  Future<int> getProductQuantity(String username, String productName) async {
    return await _dbHelper.getProductQuantity(username, productName);
  }

  // Method to calculate total price
  double calculateTotalPrice() {
    double total = 0.0;
    for (var product in cartProducts) {
      total += product['price'] * product['quantity'];
    }
    return total;
  }

  Future<void> removeFromCart(String username, String productName) async {
    await _dbHelper.removeCartProduct(username, productName);
    await loadCartProducts(username); // Reload the cart products
  }
}
