import 'package:flutter/material.dart';
import 'package:my_app/model/category_model.dart';
import 'package:my_app/model/create_product_model.dart';
import 'package:my_app/model/new_cart_item_model.dart';
import 'package:my_app/model/new_product_model.dart';
import 'package:my_app/services/product_service.dart';

class NewProductProvider extends ChangeNotifier {
  final ProductService _apiService = ProductService();

  List<NewProductModel> products = [];

  final List<NewProductModel> _wishlist = [];
  final List<NewCartItemModel> _cart = [];

  List<NewProductModel> get wishlist => _wishlist;
  List<NewCartItemModel> get cart => _cart;

  bool isLoading = false;

  Future<void> getProducts() async {
    isLoading = true;
    notifyListeners();

    try {
      products = await _apiService.fetchProducts();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<CreateProductModel?> createProduct(CreateProductModel product) async {
    isLoading = true;
    notifyListeners();

    try {
      final createdProduct = await _apiService.createProduct(product);
      products.add(
        NewProductModel(
          id: createdProduct.id ?? DateTime.now().millisecondsSinceEpoch,
          title: createdProduct.title,
          slug:
              createdProduct.slug ??
              createdProduct.title.toLowerCase().replaceAll(' ', '-'),
          price: createdProduct.price,
          description: createdProduct.description,
          category: CategoryModel(
            id: createdProduct.categoryId,
            name:
                createdProduct.categoryName ??
                'Category ${createdProduct.categoryId}',
            image: createdProduct.categoryImage ?? '',
            slug:
                createdProduct.categorySlug ??
                'category-${createdProduct.categoryId}',
          ),
          images: createdProduct.images,
        ),
      );
      return createdProduct;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProduct(int id, {String? title, int? price}) async {
    isLoading = true;
    notifyListeners();

    try {
      final existing = products.firstWhere((product) => product.id == id);

      final updates = <String, dynamic>{
        'title': title ?? existing.title,
        'price': price ?? existing.price,
        'description': existing.description,
        'categoryId': existing.category.id,
        'images': existing.images,
      };

      final updated = await _apiService.updateProduct(id, updates);
      final index = products.indexWhere((product) => product.id == id);

      if (index != -1) {
        final existing = products[index];
        products[index] = NewProductModel(
          id: existing.id,
          title: updated.title,
          slug: updated.slug ?? existing.slug,
          price: updated.price,
          description: existing.description,
          category: existing.category,
          images: existing.images,
        );
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteProduct(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final success = await _apiService.deleteProduct(id);
      if (success) {
        products.removeWhere((product) => product.id == id);
      }
      return success;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleWishlist(NewProductModel product) {
    final exists = _wishlist.any((item) => item.id == product.id);

    if (exists) {
      _wishlist.removeWhere((item) => item.id == product.id);
    } else {
      _wishlist.add(product);
    }

    notifyListeners();
  }

  bool isInWishlist(int id) {
    return _wishlist.any((product) => product.id == id);
  }

  // void clearWishlist() {

  // }

  void addToCart(NewProductModel product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(NewCartItemModel(product: product));
    }

    // print("Cart length: ${_cart.length}");
    // for (final item in _cart) {
    //   print("${item.product.name} - Qty: ${item.quantity}");
    // }

    notifyListeners();
  }

  void increaseQuantity(int productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _cart[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);

    if (index == -1) return;

    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }

    notifyListeners();
  }

  void removeFromCart(int productId) {
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
