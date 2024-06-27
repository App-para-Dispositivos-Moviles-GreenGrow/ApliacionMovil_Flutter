import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_1/models/post.dart';
import 'package:http/http.dart' as http;


class PostService{
  final String baseUrl = "https://apimoviles-1.onrender.com/api/v1/post";
//  final String baseUrl = "https://my-json-server.typicode.com/AlyneRegaladoMorales/apiMovilesApp/community";


  Future<List> getAllPosts() async {
    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> postList = json.decode(response.body);
      return postList.map((map) => Post.fromJson(map)).toList();
    }
    return [];
  }

  Future<Post> createPost(Post post) async{
  
    final response = await http.post(
      Uri.parse(baseUrl), 
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(post.toJson()), 
    );
      if (response.statusCode == 201) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear el post: ${response.body}');
      }
  }

  Future<Post> getPostById(int id) async {
    http.Response response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == HttpStatus.ok){
      Map<String, dynamic> responseData = json.decode(response.body);
      return Post.fromJson(responseData);
    } else {
      throw Exception('Failed to load post with id $id');
    }
  }
}
