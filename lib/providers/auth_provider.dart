import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  AppUser? _user;
  String? _token;
  bool _loading = false;

  AppUser? get user => _user;
  String? get token => _token;
  bool get isLoading => _loading;
  bool get isLoggedIn => _token != null;

  AuthProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final id = prefs.getString('id');
    final isAdmin = prefs.getBool('isAdmin') ?? false;

    if (token != null && id != null && name != null && email != null) {
      _token = token;
      _user = AppUser(id: id, name: name, email: email, isAdmin: isAdmin);
      apiClient.setToken(_token);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await _authApi.login(email, password);
      await _setUserFromResponse(data);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final data = await _authApi.register(name, email, password);
      await _setUserFromResponse(data);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _setUserFromResponse(Map<String, dynamic> data) async {
    _token = data['token'];
    _user = AppUser(
      id: data['_id'],
      name: data['name'],
      email: data['email'],
      isAdmin: data['isAdmin'] ?? false,
    );
    apiClient.setToken(_token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('id', _user!.id);
    await prefs.setString('name', _user!.name);
    await prefs.setString('email', _user!.email);
    await prefs.setBool('isAdmin', _user!.isAdmin);
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    apiClient.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
