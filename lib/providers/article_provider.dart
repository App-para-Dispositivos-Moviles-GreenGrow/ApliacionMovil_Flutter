import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  bool _loading = true;

  List<Article> get articles => _articles;
  bool get loading => _loading;

  ArticleProvider() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final url = 'https://yancefranco.github.io/pruebajson/db.json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List articlesData = data['tendencias'];
        _articles = articlesData.map((json) => Article.fromJson(json)).toList();
        print('Articles fetched: ${_articles.length}');
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (error) {
      print('Error fetching articles: $error');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
