class CategoryModel {
  final int id;
  final String name;
  final String image;
  final String slug;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      slug: json["slug"],
    );
  }
}