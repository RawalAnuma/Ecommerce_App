import 'package:flutter/material.dart';
import 'package:my_app/model/create_user_model.dart';
import 'package:my_app/model/user_model.dart';
import 'package:my_app/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  List<UserModel> users = [];

  bool isLoading = false;

  Future<void> getUsers() async {
    isLoading = true;
    notifyListeners();

    try {
      users = await _userService.fetchUsers();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  Future<CreateUserModel?> createUser(CreateUserModel user) async {
    isLoading = true;
    notifyListeners();

    try {
      final createdUser = await _userService.createUser(user);

      users.add(
        UserModel(
          id: createdUser.id ?? DateTime.now().millisecondsSinceEpoch,
          name: createdUser.name,
          email: createdUser.email,
          avatar: createdUser.avatar,
          role: createdUser.role,
        ),
      );

      return createdUser;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
