import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/services/profile_service.dart';
import 'package:flutter_application_1/session/user_session.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String _baseUrl = 'https://backend-flask-3.onrender.com/login'; // URL del endpoint Flask
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

        UserSession.setUsername(username);
        ProfileService _profileService = ProfileService();
        var profile = await _profileService.fetchProfile(username);
        UserSession.setRole(profile!.role);
        print(profile.role);

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
