import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/model/category_model.dart';

class CategoryService {
  static const String url = "https://api.escuelajs.co/api/v1/categories";

  //GET: Fetch all categories
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load categories");
  }

  // POST:Create a new category
  Future<CategoryModel> createCategory(Map<String, dynamic> category) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(category),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data);
    }
    throw Exception(
      "Failed to create category: "
      "${response.statusCode} ${response.body}",
    );
  }

  // PUT:Update category
  Future<CategoryModel> updateCategory(
    int id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.put(
      Uri.parse('$url/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updates),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CategoryModel.fromJson(data);
    }
    throw Exception(
      "Failed to update category: "
      "${response.statusCode} ${response.body}",
    );
  }

  // DELETE:Delete category
  Future<bool> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$url/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) == true;
    }
    throw Exception(
      "Failed to delete category: "
      "${response.statusCode} ${response.body}",
    );
  }
}
