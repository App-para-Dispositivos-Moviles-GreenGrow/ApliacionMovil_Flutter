class Profile {
  final String dni;
  final String role;
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String city;
  final String? imagePath;  // Campo para el path de la imagen

  Profile({
    required this.dni,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.country,
    required this.city,
    this.imagePath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      dni: json['dni'],
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      country: json['country'],
      city: json['city'],
      imagePath: json['image_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'country': country,
      'city': city,
      'image_path': imagePath,
    };
  }
}

