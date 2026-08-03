import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/model/create_user_model.dart';
import 'package:my_app/model/user_model.dart';

class UserService {
  static const String url = "https://api.escuelajs.co/api/v1/users";

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    }

    throw Exception("Failed tto load users");
  }

  Future<CreateUserModel> createUser(CreateUserModel user) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CreateUserModel.fromJson(data);
    }

    throw Exception(
      "Failed to create user: ${response.statusCode} ${response.body}",
    );
  }
}
