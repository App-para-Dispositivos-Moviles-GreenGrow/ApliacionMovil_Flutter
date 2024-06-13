import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/profile.dart';

class ProfileService {
  final String baseUrl = "https://my-json-server.typicode.com/GioRC0/GreenGrowFakeApi/profile";

  Future<Profile?> fetchProfile() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body);
        return Profile.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}


//cambiar cuando se cree el api para gestionar el perfil con el incio de sesion