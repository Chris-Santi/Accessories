class WishlistManager {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;

  final List<Map<String, dynamic>> _wishlist = [];

  WishlistManager._internal();

  List<Map<String, dynamic>> getWishlist() => _wishlist;

  void addToWishlist(Map<String, dynamic> product) {
    if (!_wishlist.any((item) => item['id'] == product['id'])) {
      _wishlist.add(product);
    }
  }

  void removeFromWishlist(int productId) {
    _wishlist.removeWhere((item) => item['id'] == productId);
  }
}
