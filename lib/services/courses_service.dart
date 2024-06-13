import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/models/course.dart';
import 'package:http/http.dart' as http;

class CourseService {
  final String baseUrl = "https://my-json-server.typicode.com/GioRC0/GreenGrowFakeApi/courses";

  Future<List<Course>> searchCourses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body) as List;
      return jsonResponse.map((map) => Course.fromJson(map)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
