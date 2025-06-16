import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistPage extends StatefulWidget {
  final List<Map<String, dynamic>> wishlist;

  WishlistPage({required this.wishlist});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late List<Map<String, dynamic>> wishlist;

  @override
  void initState() {
    super.initState();
    wishlist = List<Map<String, dynamic>>.from(widget.wishlist);
  }

  void removeFromWishlist(dynamic id) {
    setState(() {
      wishlist.removeWhere((product) => product['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Wishlist',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body:
          wishlist.isEmpty
              ? Center(child: Text('No items in wishlist'))
              : ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlist[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors.primaries[index % Colors.primaries.length][50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Image.network(
                        product['image'],
                        width: 40,
                        height: 40,
                      ),
                      title: Text(product['title']),
                      subtitle: Text("₦ ${product['price']}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          removeFromWishlist(product['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
