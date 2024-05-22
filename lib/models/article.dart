class Article {
  final int id;
  final String imageUrl;
  final String title;
  final String date;
  final String description;
  final String url;

  Article({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.description,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      imageUrl: json['imagen'],
      title: json['titulo'],
      date: json['fecha'],
      description: json['descripcion'],
      url: json['enlace'],
    );
  }
}
