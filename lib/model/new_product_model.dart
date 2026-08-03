import 'package:my_app/model/category_model.dart';

class NewProductModel {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final CategoryModel category;
  final List<String> images;

  NewProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory NewProductModel.fromJson(Map<String, dynamic> json) {
    return NewProductModel(
      id: json["id"],
      title: json["title"],
      slug: json["slug"],
      price: json["price"],
      description: json["description"],
      category: CategoryModel.fromJson(json["category"]),
      images: List<String>.from(json["images"]),
    );
  }
}