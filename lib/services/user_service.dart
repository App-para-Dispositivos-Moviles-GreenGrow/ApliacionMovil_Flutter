import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'https://yancefranco.github.io/pruebajson0.1/db.json';
  final String _username = 'username=';
  final String _password = '&password=';

  Future<bool> authenticate(String username, String password) async {
    final url = '$_baseUrl$_username$username$_password$password';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = response.body;
      final users = json.decode(jsonResponse);
      return users.isNotEmpty;
    }
    return false;
  }
}
 
