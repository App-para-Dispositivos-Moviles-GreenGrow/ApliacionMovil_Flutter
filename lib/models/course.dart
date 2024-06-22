class Course {
  final String name;
  final int price;
  final String description;
  final String image;
  final String videoUrl;

  Course({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.videoUrl,
  });

  Course.fromJson(Map<String, dynamic> map)
      : name = map["name"],
        price = map["price"],
        image = map["image"],
        description = map["description"],
        videoUrl = map["videoUrl"];
}
