import 'dart:convert';
import 'package:accessories/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_page.dart';
import 'cart_page.dart';
import 'wishlist_page.dart';
import 'profile_page.dart';

bool _seeAllClicked = false;

// Search Delegate for searching products
class ProductSearchDelegate extends SearchDelegate {
  final List products;
  final List<dynamic> _wishlist;

  ProductSearchDelegate(this.products, this._wishlist);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context); // Show suggestions again
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Closes the search
        showSuggestions(context); // Show suggestions again
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        products
            .where(
              (product) => product['title'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(product['image'], width: 40, height: 40),
          title: Text(product['title']),
          subtitle: Text("₦ ${product['price']}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductPage(product: product)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        products
            .where(
              (product) => product['title'].toString().toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: Image.network(product['image'], width: 40, height: 40),
          title: Text(product['title']),
          subtitle: Text("₦ ${product['price']}"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductPage(product: product)),
            );
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  int _currentIndex = 0;
  List<dynamic> _wishlist = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products'),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          products = json.decode(response.body);
        });
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  List<String> banners = [
    'assets/images/banner1.png', // replace with actual images
    'assets/images/banner2.png',
  ];

  List<dynamic> categoryIcons = [
    Icons.diamond,
    Icons.male,
    Icons.female,
    Icons.devices,
  ];
  int _selectedCategoryIndex = 0;

  // Map each icon to its corresponding category string from the API
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.diamond, 'category': 'jewelery'},
    {'icon': Icons.male, 'category': "men's clothing"},
    {'icon': Icons.female, 'category': "women's clothing"},
    {'icon': Icons.devices, 'category': 'electronics'},
  ];
  // Helper to get category name for each icon
  // Filter products based on selected category
  List get filteredProducts {
    if (_selectedCategoryIndex == -1) {
      return products;
    }
    String selectedCategory = categories[_selectedCategoryIndex]['category'];
    return products.where((p) => p['category'] == selectedCategory).toList();
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow to match Scaffold background
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          onSelected: (value) {
            if (value == 'Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage()),
              );
            } else if (value == 'About') {
              showAboutDialog(
                context: context,
                applicationName: 'Accessories App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Accessories',
              );
            } else if (value == 'Contact Us') {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Contact Us'),
                      content: Text(
                        'Email: support@accessories.com\nPhone: +234 123 4567',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            } else if (value == 'Logout') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Logged out')));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'Profile', child: Text('Profile')),
                PopupMenuItem(value: 'About', child: Text('About')),
                PopupMenuItem(value: 'Contact Us', child: Text('Contact Us')),
                PopupMenuItem(value: 'Logout', child: Text('Logout')),
              ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: ProductSearchDelegate(products, _wishlist),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ), // Close AppBar here

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello Fola 👋",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                " Let's  start  shopping! ",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12),

              // Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 140,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items:
                    banners.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String imageAsset = entry.value;

                      // Define title and navigation logic per banner
                      final List<String> titles = [
                        "20% OFF DURING THE \n WEEKEND",
                        "20% OFF DURING THE \n WEEKEND",
                      ];
                      final List<VoidCallback> onPressedActions = [
                        () {
                          // Example: Navigate to Women's category
                          setState(() {
                            _selectedCategoryIndex =
                                2; // Index of "women's clothing"
                          });
                        },
                        () {
                          // Example: Navigate to Jewelery category
                          setState(() {
                            _selectedCategoryIndex = 0; // Index of "jewelery"
                          });
                        },
                      ];

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: idx == 0 ? Colors.orange : Color(0xff1383F1),
                        ),
                        child: Row(
                          children: [
                            // Left side: text and button
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    titles[idx == 0 ? 0 : 1],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed:
                                        onPressedActions[idx == 0 ? 0 : 1],
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          idx == 0
                                              ? Colors.white
                                              : Color(0xff50D63B),
                                      foregroundColor:
                                          idx == 0
                                              ? Colors.orange
                                              : Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      "Get Now",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            // Right side: image
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  imageAsset,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Categories",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex =
                              -1; // Reset to show all products
                          _seeAllClicked = !_seeAllClicked; // Toggle the state
                          _seeAllClicked = true;
                        });

                        // Revert the style after 350 milliseconds
                        Future.delayed(Duration(milliseconds: 350), () {
                          if (mounted) {
                            setState(() {
                              _seeAllClicked = false;
                            });
                          }
                        });
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(
                          color:
                              _seeAllClicked
                                  ? Colors.deepOrange
                                  : Colors.orange,
                          // decoration: TextDecoration.underline,
                          fontWeight:
                              _seeAllClicked
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              SizedBox(
                height:
                    MediaQuery.of(context).size.width *
                    0.17, // allows icon + padding
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryIcons.length,
                  itemBuilder:
                      (context, index) => GestureDetector(
                        onTap: () => _onCategoryTap(index),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double iconContainerSize =
                                MediaQuery.of(context).size.width * 0.13;
                            // Ensure iconContainerSize fits within available height and doesn't overflow
                            double maxHeight =
                                MediaQuery.of(context).size.width * 0.17;
                            // Add spacing between containers by wrapping with Padding
                            iconContainerSize = iconContainerSize.clamp(
                              40.0,
                              maxHeight - 10, // leave some padding
                            );

                            // Add horizontal padding to create space between containers
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ), // adjust as needed
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: 25),
                                child: Column(
                                  children: [
                                    Container(
                                      width: iconContainerSize,
                                      height: iconContainerSize,
                                      decoration: BoxDecoration(
                                        color:
                                            index == _selectedCategoryIndex
                                                ? Colors.orange
                                                : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Icon(
                                            categoryIcons[index],
                                            color:
                                                index == _selectedCategoryIndex
                                                    ? Colors.white
                                                    : Colors.black,
                                            size: iconContainerSize * 0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                ),
              ),
              SizedBox(height: 16),

              // Product Grid
              GridView.builder(
                // Use filteredProducts instead of products for category filtering
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product['image'],
                                  fit: BoxFit.contain,
                                  height: 100,
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  product['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "₦ ${product['price']}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "₦ ${(product['price'] * 2).toStringAsFixed(0)}", // Example: double the current price
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Wishlist button at top right
                          Positioned(
                            top: 0,
                            right: 0,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                bool isFavorite = product['isFavorite'] == true;
                                return IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite
                                            ? Colors.orange
                                            : Colors.grey,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      product['isFavorite'] = true;
                                    });
                                    // Revert color back to grey after 350 milliseconds
                                    Future.delayed(
                                      Duration(milliseconds: 350),
                                      () {
                                        setState(() {
                                          product['isFavorite'] = false;
                                        });
                                      },
                                    );
                                    if (!_wishlist.contains(product)) {
                                      setState(() {
                                        _wishlist.add(product);
                                      });
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isFavorite
                                              ? '${product['title']} removed from wishlist'
                                              : '${product['title']} added to wishlist',
                                        ),
                                        duration: Duration(milliseconds: 800),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                "50% OFF",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Bottom Nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.orange),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => WishlistPage(
                      wishlist: _wishlist.cast<Map<String, dynamic>>(),
                    ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          }
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
