import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/models/course.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final String baseUrl = "http://10.0.2.2:5000";

  // Método GET para obtener los cursos
  Future<List<Course>> searchCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((map) => Course.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  // Método POST para agregar un curso
  Future<void> addCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'name': course.name,
        'price': course.price,
        'description': course.description,
        'image': course.image,
      }),
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception('Failed to add course');
    }
  }

  // Método POST para obtener el rol del usuario
  Future<String> getUserRole(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_user_role'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      print("Rol del usuario obtenido del servidor: ${jsonResponse['role']}");
      return jsonResponse['role'];
    } else {
      print("Error obteniendo el rol del usuario: ${response.statusCode}");
      throw Exception('Failed to get user role');
    }
  }
}
