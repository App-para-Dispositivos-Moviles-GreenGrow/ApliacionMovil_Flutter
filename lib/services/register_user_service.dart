import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterUserService {
  final String _baseUrl = 'https://backend-flask-3.onrender.com';

  Future<bool> register(String dni, String role, String firstName, String lastName, String email, String username, String password, String country, String city, [String? imageUrl]) async {
    final Map<String, String> requestBody = {
      'dni': dni,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': username,
      'password': password,
      'country': country,
      'city': city,
    };

    if (imageUrl != null && imageUrl.isNotEmpty) {
      requestBody['image_url'] = imageUrl;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
