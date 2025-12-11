import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config.dart';

class ApiClient {
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<dynamic> get(String path) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final res = await http.get(uri, headers: _headers());
    _handleError(res);
    return jsonDecode(res.body);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final res = await http.post(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    _handleError(res);
    return jsonDecode(res.body);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final res = await http.put(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    _handleError(res);
    return jsonDecode(res.body);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final res = await http.delete(uri, headers: _headers());
    _handleError(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  void _handleError(http.Response res) {
    if (res.statusCode >= 400) {
      throw Exception('API error: ${res.statusCode} ${res.body}');
    }
  }
}

final apiClient = ApiClient();
