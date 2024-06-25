import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/models/course.dart';
import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = "http://10.0.2.2:5000";

  Future<void> addCourseToShoppintCart(String username, int courseId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shopping_cart'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'course_id': courseId
      }),
    );

    if (response.statusCode != HttpStatus.created) {
      throw Exception("Failed to add course to shopping cart");
    }
  }

  Future<void> deleteCourseFromShoppingCart(String username, int courseId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/shopping_cart'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode({
        'username': username,
        'course_id': courseId
      })
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception("Failed to delete course from shopping cart");
    }
  }

  Future<List<Course>> getShoppingCart(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/shopping_cart/$username'));
      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body) as List;
        return jsonResponse.map((map) => Course.fromJson(map)).toList();
      } else {
        throw Exception('Failed to load courses');
      }
  }

  Future<void> processShoppingCart(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/process_shopping_cart'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'username': username
      })
      );
    if (response.statusCode != HttpStatus.ok){
      throw Exception('Failed to process shopping cart');
    }
  }
}