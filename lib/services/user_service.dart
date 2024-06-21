import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'http://10.0.2.2:5000/login'; // URL del endpoint Flask

  Future<bool> authenticate(String username, String password) async {
    final url = _baseUrl;

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        return true;
      } else {
        print('Error de autenticación: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }
}
