import 'package:accessories/services/api_services/cart_manager.dart';
import 'package:accessories/views/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle = Rect.fromLTRB(
      0,
      0,
      size.width,
      size.height - roundingHeight,
    );
    final roundingRectangle = Rect.fromLTRB(
      -5,
      size.height - roundingHeight * 2,
      size.width + 5,
      size.height,
    );

    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedSize = 37;
  int selectedColorIndex = 0;
  final List<Color> colors = [Colors.blueGrey, Colors.black, Colors.white];
  final List<int> sizes = [35, 36, 37, 38, 39, 40];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable content including background
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clipped background that scrolls
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: 280,
                    color: Color(0xffD8D8D8),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.network(
                              product['image'],
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Color Selector
                Padding(
                  padding: const EdgeInsets.only(
                    left: 100,
                    top: 0,
                  ), // set top padding to 0 to avoid negative padding error
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Color(0xffD8D8D8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                            // Add a border only if the selected color is white
                            // the white should have a border of #0xff000000 so it can be visible on the container
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 0,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(colors.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                width: 28,
                                height: 28,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colors[index],
                                        border: Border.all(
                                          color:
                                              colors[index] == Colors.white
                                                  ? Colors
                                                      .black // white needs border
                                                  : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    if (selectedColorIndex == index)
                                      Icon(
                                        Icons.check,
                                        size: 14,
                                        color:
                                            colors[index] == Colors.white
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Product Title
                      Text(
                        product['title'],
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating Row
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            "${product['rating']['rate']}",
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            "₦ ${product['price']}",
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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
                          const Spacer(),
                          Text(
                            "Available in stock",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // About Section
                      Text(
                        "About",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product['description'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Size Selector
                      Text(
                        "Select Size",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            sizes.map((size) {
                              return GestureDetector(
                                onTap:
                                    () => setState(() => selectedSize = size),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        selectedSize == size
                                            ? Colors.orange.shade100
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          selectedSize == size
                                              ? Colors.orange
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    "$size",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          selectedSize == size
                                              ? Colors.orange
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Category
                      Text(
                        "Category: ${product['category']}",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Add more info or widgets to fill space
                      Text(
                        "Shipping: Free delivery within 3-5 days.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Return Policy: 7 days return policy available.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Text(
                        "Features",
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check, color: Colors.orange, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "High quality material",
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.check, color: Colors.orange, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Trendy design",
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.check, color: Colors.orange, size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Comfortable fit",
                                style: GoogleFonts.inter(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 100), // for bottom button spacing
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Persistent bottom Add to Cart Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      CartManager().addToCart(widget.product);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Added to cart")));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add to cart",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
