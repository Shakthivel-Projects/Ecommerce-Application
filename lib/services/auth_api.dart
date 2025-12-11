import '../models/user.dart';
import 'api_client.dart';

class AuthApi {
  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final data = await apiClient.post('/auth/register', {
      'name': name,
      'email': email,
      'password': password,
    });
    return data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final data = await apiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return data;
  }
}
