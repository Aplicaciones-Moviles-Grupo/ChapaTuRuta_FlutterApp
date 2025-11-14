import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  static const String _userKey = 'current_user';
  
  // Usuario de ejemplo (simulando autenticación)
  final UserModel _defaultUser = UserModel(
    id: '1',
    name: 'Sabrina',
    lastName: 'Aryan',
    username: 'sabrina',
    email: 'sabrinArya20@gmail.com',
    phone: '+51 004 6470',
    gender: 'Mujer',
    favoriteRoutes: [],
  );

  @override
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userData = json.decode(userJson);
        return UserModel.fromJson(userData);
      }
      
      // Si no hay usuario guardado, usar el default
      await _saveUser(_defaultUser);
      return _defaultUser;
    } catch (e) {
      return _defaultUser;
    }
  }

  @override
  Future<void> updateUser(User user) async {
    await _saveUser(user);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      phone: user.phone,
      gender: user.gender,
      favoriteRoutes: user.favoriteRoutes,
    );
    await prefs.setString(_userKey, json.encode(userModel.toJson()));
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<void> addFavoriteRoute(String routeId) async {
    final user = await getCurrentUser();
    if (user != null && !user.favoriteRoutes.contains(routeId)) {
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        lastName: user.lastName,
        username: user.username,
        email: user.email,
        phone: user.phone,
        gender: user.gender,
        favoriteRoutes: [...user.favoriteRoutes, routeId],
      );
      await _saveUser(updatedUser);
    }
  }

  @override
  Future<void> removeFavoriteRoute(String routeId) async {
    final user = await getCurrentUser();
    if (user != null) {
      final updatedRoutes = user.favoriteRoutes.where((id) => id != routeId).toList();
      final updatedUser = UserModel(
        id: user.id,
        name: user.name,
        lastName: user.lastName,
        username: user.username,
        email: user.email,
        phone: user.phone,
        gender: user.gender,
        favoriteRoutes: updatedRoutes,
      );
      await _saveUser(updatedUser);
    }
  }
}