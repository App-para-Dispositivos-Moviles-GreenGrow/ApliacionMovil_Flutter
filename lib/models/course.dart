class Course {
  final int? id;
  final String name;
  final int price;
  final String description;
  final String image;
  final String videoUrl;

  Course({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.videoUrl,
  });

  Course.fromJson(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        price = map["price"],
        image = map["image"],
        description = map["description"],
        videoUrl = map["videoUrl"];
}
