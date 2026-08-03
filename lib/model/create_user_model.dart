class CreateUserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String avatar;
  final String role;

  CreateUserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.avatar,
    this.role = "customer",
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      password: json["password"] ?? "",
      avatar: json["avatar"],
      role: json["role"] ?? "customer",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "avatar": avatar,
      "role": role,
    };
  }
}