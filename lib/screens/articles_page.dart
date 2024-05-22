import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart';

class ArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artículos'),
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          if (articleProvider.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (articleProvider.articles.isEmpty) {
            return Center(child: Text('No articles available.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: articleProvider.articles.map((article) {
                return ArticleCard(article: article);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
