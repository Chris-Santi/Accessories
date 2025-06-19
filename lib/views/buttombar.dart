import 'package:accessories/views/cart_page.dart';
import 'package:accessories/views/home_page.dart';
import 'package:accessories/views/profile_page.dart';
import 'package:accessories/views/wishlist_page.dart';
import 'package:flutter/material.dart';

class ButtomBarPage extends StatefulWidget {
  const ButtomBarPage({super.key});

  @override
  State<ButtomBarPage> createState() => _ButtomBarPageState();
}

class _ButtomBarPageState extends State<ButtomBarPage> {
  int _currentIndex = 0;
  List<dynamic> _wishlist = [];
  @override
  Widget build(BuildContext context) {
    final List<Widget> _allPages = [
      HomePage(),
      WishlistPage(wishlist: _wishlist.cast<Map<String, dynamic>>()),
      CartPage(),
      ProfilePage(),
    ];

    return Scaffold(
      body: _allPages[_currentIndex],
      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.orange),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.grey),
            label: "Wishlist",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.grey),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
