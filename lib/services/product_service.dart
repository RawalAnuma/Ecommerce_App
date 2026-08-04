import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:my_app/model/create_product_model.dart';
import 'package:my_app/model/new_product_model.dart';

class ProductService {
  static const String url = "https://api.escuelajs.co/api/v1/products";
  static const String uploadUrl =
      "https://api.escuelajs.co/api/v1/files/upload";

  Future<List<NewProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((e) => NewProductModel.fromJson(e))
          .toList();
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

  Future<CreateProductModel> updateProduct(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.put(
      Uri.parse('$url/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updates), //convert Dart Object to JSON string
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(
        response.body,
      ); // convert JSON string to Dart Object
      return CreateProductModel.fromJson(data);
    }

    throw Exception(
      "Failed to update product: "
      "${response.statusCode} ${response.body}",
    );
  }

  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) == true;
    }

    throw Exception(
      "Failed to delete product: "
      "${response.statusCode} ${response.body}",
    );
  }

  Future<String> uploadImage(File file) async {
    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['location'];
    }

    throw Exception(
      "Failed to upload image: "
      "${response.statusCode} ${response.body}",
    );
  }
}
