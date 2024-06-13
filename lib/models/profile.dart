class Profile {
  final String city;
  final String country;
  final String? image;

  Profile({required this.city, required this.country, this.image});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      city: json['city'],
      country: json['country'],
      image: json['image'],
    );
  }
}


//cambiar cuando se cree el api para gestionar el perfil con el incio de sesion