// import 'package:flutter/material.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;

  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];

  // Removed duplicate addToCart method to resolve duplicate definition error.

  // Add this method to update the quantity of an item in the cart
  void updateQuantity(int index, bool increase) {
    if (index < 0 || index >= items.length) return;
    if (increase) {
      items[index]['quantity'] += 1;
    } else {
      if (items[index]['quantity'] > 1) {
        items[index]['quantity'] -= 1;
      } else {
        // Add this method to get the total price of items in the cart
        double getTotalPrice() {
          return _items.fold(
            0.0,
            (total, item) => total + (item['price'] * item['quantity']),
          );
        }
      }
    }
  }

  List<Map<String, dynamic>> get items => _items;

  void addToCart(Map<String, dynamic> product) {
    // Check if the product already exists in the cart (by id)
    final existingIndex = _items.indexWhere(
      (item) => item['id'] == product['id'],
    );
    if (existingIndex != -1) {
      // If exists, just increase the quantity
      _items[existingIndex]['quantity'] += product['quantity'] ?? 1;
    } else {
      // Ensure 'quantity' field exists and is an integer
      if (!product.containsKey('quantity') || product['quantity'] == null) {
        product['quantity'] = 1;
      }
      _items.add(Map<String, dynamic>.from(product));
    }
  }

  void removeFromCart(int index) {
    _items.removeAt(index);
  }

  void clearCart() {
    _items.clear();
  }
}
