import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Fetch all products
  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch single product (optional)
  Future<Map<String, dynamic>> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  // Add a cart (mock example - POST request)
  Future<void> addToCart(
    int userId,
    List<Map<String, dynamic>> products,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'date': DateTime.now().toIso8601String(),
        'products':
            products
                .map((p) => {'productId': p['id'], 'quantity': p['quantity']})
                .toList(),
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add to cart');
    }
  }

  // Fetch cart (optional)
  Future<List<dynamic>> fetchCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/carts/user/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cart');
    }
  }
}
