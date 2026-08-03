import 'package:my_app/model/new_product_model.dart';

class NewCartItemModel {
  final NewProductModel product;
  int quantity;

  NewCartItemModel({
    required this.product,
    this.quantity = 1,
  });

  int get totalPrice => product.price * quantity;
}