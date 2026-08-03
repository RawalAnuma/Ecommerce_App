import 'package:flutter/material.dart';
import 'package:my_app/model/category_model.dart';
import 'package:my_app/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<CategoryModel> categories = [];

  bool isLoading = false;

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _service.fetchCategories();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}
