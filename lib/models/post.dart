class Post{
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final String autor;

  Post({required this.id, required this.title, required this.description, required this.imageUrl,required this.autor});

  factory Post.fromJson(Map<String, dynamic> json){
        return Post(
        id : json['id'],
        title : json['title'],
        description : json['description'],
        imageUrl : json['imageUrl'],
        autor : json['autor']
        );
  }
      


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'autor': autor
    };
  } 
}