import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_app/model/category_model.dart';
import 'package:my_app/services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider({CategoryService? apiService})
    : _apiService = apiService ?? CategoryService();

  final CategoryService _apiService;

  List<CategoryModel> categories = [];

  bool isLoading = false;

  Future<void> getCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      categories = await _apiService.fetchCategories();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<CategoryModel?> createCategory({
    required String name,
    required String image,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final createdCategory = await _apiService.createCategory({
        "name": name,
        "image": image,
      });
      categories.add(createdCategory);
      return createdCategory;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCategory(int id, {String? name, String? image}) async {
    isLoading = true;
    notifyListeners();
    try {
      final existing = categories.firstWhere((category) => category.id == id);
      final updates = <String, dynamic>{
        "name": name ?? existing.name,
        "image": image ?? existing.image,
      };
      final updated = await _apiService.updateCategory(id, updates);
      final index = categories.indexWhere((category) => category.id == id);
      if (index != -1) {
        categories[index] = CategoryModel(
          id: existing.id,
          name: updated.name,
          image: updated.image,
          slug: updated.slug,
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

  Future<bool> deleteCategory(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      final success = await _apiService.deleteCategory(id);
      if (success) {
        categories.removeWhere((category) => category.id == id);
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

  Future<String?> uploadImage(File file) async {
    try {
      return await _apiService.uploadImage(file);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
