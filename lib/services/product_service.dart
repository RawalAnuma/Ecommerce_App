import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/model/create_product_model.dart';
import 'package:my_app/model/new_product_model.dart';

class ProductService {
  static const String url = "https://api.escuelajs.co/api/v1/products";

  Future<List<NewProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => NewProductModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load products");
  }

  Future<CreateProductModel> createProduct(CreateProductModel product) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},

      // Converts Dart Map into a JSON string.
      body: jsonEncode(product.toJson()),
    );

    // Only process the response if the request succeeded.
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Converts JSON string back into a Dart Map.
      final data = jsonDecode(response.body);

      return CreateProductModel.fromJson(data);
    }

    throw Exception(
      "Failed to create product: "
      "${response.statusCode} ${response.body}",
    );
  }
}
