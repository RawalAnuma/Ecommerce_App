import 'package:flutter/material.dart';
import 'package:my_app/model/cart_item_model.dart';

import '../model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [
    ProductModel(
      id: '1',
      name: 'Essence Organic Hoodie',
      imageUrl:
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&q=80&w=400',
      price: 120.00,
      oldPrice: 165.00,
      rating: 4.9,
      category: 'Clothing',
    ),
    ProductModel(
      id: '2',
      name: 'Vanguard Chelsea Boots',
      imageUrl:
          'https://images.unsplash.com/photo-1638247025967-b4e38f787b76?auto=format&fit=crop&q=80&w=400',
      price: 245.00,
      oldPrice: 310.00,
      rating: 4.8,
      category: 'Accessories',
    ),
    ProductModel(
      id: '3',
      name: 'Archibald Wool Coat',
      imageUrl:
          'https://images.unsplash.com/photo-1539533377285-b82420a6e033?auto=format&fit=crop&q=80&w=400',
      price: 380.00,
      oldPrice: 450.00,
      rating: 5.0,
      category: 'Clothing',
    ),
    ProductModel(
      id: '4',
      name: 'Horizon Aviators',
      imageUrl:
          'https://images.unsplash.com/photo-1572635196237-14b3f281503f?auto=format&fit=crop&q=80&w=400',
      price: 185.00,
      oldPrice: 215.00,
      rating: 4.7,
      category: 'Accessories',
    ),
    ProductModel(
      id: '5',
      name: 'Linen Weekend Shirt',
      imageUrl:
          'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&q=80&w=400',
      price: 98.00,
      oldPrice: 125.00,
      rating: 4.6,
      category: 'Clothing',
    ),
    ProductModel(
      id: '6',
      name: 'Canvas Crossbody Bag',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=400',
      price: 142.00,
      oldPrice: 168.00,
      rating: 4.8,
      category: 'Accessories',
    ),
    ProductModel(
      id: '7',
      name: 'Everyday Sneakers',
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=400',
      price: 160.00,
      oldPrice: 190.00,
      rating: 4.9,
      category: 'Accessories',
    ),
    ProductModel(
      id: '8',
      name: 'Minimal Knit Sweater',
      imageUrl:
          'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&q=80&w=400',
      price: 134.00,
      oldPrice: 159.00,
      rating: 4.7,
      category: 'Clothing',
    ),
  ];

  final List<ProductModel> _wishlist = [];
  final List<CartItemModel> _cart = [];

  List<ProductModel> get products => List.unmodifiable(_products);
  List<ProductModel> get wishlistItems => List.unmodifiable(_wishlist);
  List<CartItemModel> get cartItems => List.unmodifiable(_cart);

  void addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
  }

  void addProductFromFields({
    required String name,
    required String imageUrl,
    required double price,
    double? oldPrice,
    required double rating,
    required String category,
  }) {
    addProduct(
      ProductModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        imageUrl: imageUrl,
        price: price,
        oldPrice: oldPrice,
        rating: rating,
        category: category,
      ),
    );
  }

  void removeProduct(String id) {
    _products.removeWhere((product) => product.id == id);
    _wishlist.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void clearList() {
    _products.clear();
    _wishlist.clear();
    notifyListeners();
  }

  void toggleWishlist(ProductModel product) {
    final exists = _wishlist.any((item) => item.id == product.id);

    if (exists) {
      _wishlist.removeWhere((item) => item.id == product.id);
    } else {
      _wishlist.add(product);
    }

    notifyListeners();
  }

  bool isInWishlist(String id) {
    return _wishlist.any((product) => product.id == id);
  }

  // void clearWishlist() {

  // }

  void addToCart(ProductModel product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItemModel(product: product));
    }

    // print("Cart length: ${_cart.length}");
    // for (final item in _cart) {
    //   print("${item.product.name} - Qty: ${item.quantity}");
    // }

    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }

    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);

    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return _cart.fold(0, (sum, item) => sum + item.quantity);
  }
}
