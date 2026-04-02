import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_labs/config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers({String? token}) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await _client.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginPath}'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _client.post(
      Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.registerPath}',
      ),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  Future<List<dynamic>> getRooms(String token) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.roomsPath}'),
      headers: _headers(token: token),
    );
    final data = _handleResponse(response);
    return data['rooms'] as List<dynamic>? ?? [];
  }

  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await _client.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userPath}'),
      headers: _headers(token: token),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message =
        body['message'] as String? ?? 'Request failed';
    throw ApiException(message, statusCode: response.statusCode);
  }

  void dispose() {
    _client.close();
  }
}
