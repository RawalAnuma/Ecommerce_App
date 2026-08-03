import 'dart:convert';

CreateProductModel createProductModelFromJson(String str) =>
    CreateProductModel.fromJson(json.decode(str));

String createProductModelToJson(CreateProductModel data) =>
    json.encode(data.toJson());

class CreateProductModel {
  String title;
  int price;
  String description;
  int categoryId;
  List<String> images;
  String? slug;
  int? id;
  String? categoryName;
  String? categoryImage;
  String? categorySlug;

  CreateProductModel({
    required this.title,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.images,
    this.slug,
    this.id,
    this.categoryName,
    this.categoryImage,
    this.categorySlug,
  });

  factory CreateProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    return CreateProductModel(
      title: json['title'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse('${json['price']}') ?? 0,
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? (category != null ? category['id'] : 1),
      images: List<String>.from(
        (json['images'] ?? []).map((x) => x.toString()),
      ),
      slug: json['slug'],
      id: json['id'],
      categoryName: category != null ? category['name'] : null,
      categoryImage: category != null ? category['image'] : null,
      categorySlug: category != null ? category['slug'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'price': price,
    'description': description,
    'categoryId': categoryId,
    'images': List<dynamic>.from(images.map((x) => x)),
  };
}
