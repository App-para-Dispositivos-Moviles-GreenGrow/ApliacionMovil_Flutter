import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'https://yancefranco.github.io/pruebajson0.1/db.json';

  Future<bool> authenticate(String username, String password) async {
    final url = '$_baseUrl';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body) as List;
        for (var user in jsonResponse) {
          if (user['username'] == username && user['password'] == password) {
            return true;
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }
}
