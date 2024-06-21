import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterUserService {
  final String _baseUrl = 'http://10.0.2.2:5000';

  Future<bool> register(String dni, String role, String firstName, String lastName, String email, String username, String password, String country, String city) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'dni': dni,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': username,
        'password': password,
        'country': country,
        'city': city,
      }),
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
