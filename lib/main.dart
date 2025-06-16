// import 'package:accessories/services/api_services/cart_manager.dart';
import 'package:accessories/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'services/api_services/cart_manager.dart';
// import 'package:accessories/views/home_page.dart';
// import 'package:flutter/foundation.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;

  CartManager._internal();

  final List<Map<String, dynamic>> _items = [];

  void addToCart(Map<String, dynamic> product) {
    _items.add(product);
    notifyListeners();
  }

  List<Map<String, dynamic>> get items => _items;

  void removeFromCart(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartManager>(create: (_) => CartManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accessories',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
