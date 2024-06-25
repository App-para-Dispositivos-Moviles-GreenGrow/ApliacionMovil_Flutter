import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class ProfileService {
  //final String baseUrl = "https://backend-flask-3.onrender.com";  // Cambia esto a la URL de tu servicio Flask
  final String baseUrl = "http://10.0.2.2:5000";
  Future<Profile?> fetchProfile(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
        }),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body);
        return Profile.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }

  Future<bool> updateProfile(Profile profile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_profile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(profile.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
}
