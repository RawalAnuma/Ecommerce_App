import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/model/category_model.dart';

class CategoryService {
  static const String url = "https://api.escuelajs.co/api/v1/categories";

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }

    throw Exception("Failed to load categories");
  }
}
