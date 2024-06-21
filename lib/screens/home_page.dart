import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de tener esta dependencia
import '../widgets/course_card.dart';
import '../widgets/image_carousel.dart';
import '../services/courses_service.dart';
import '../services/profile_service.dart';
import '../models/course.dart';
import '../models/profile.dart';
import 'profile_page.dart';  // Importa la página de perfil

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'https://i.imgur.com/ru5fwlS.jpg',
    'https://i.imgur.com/ru5fwlS.jpg',
    'https://i.imgur.com/ru5fwlS.jpg',
    'https://i.imgur.com/ru5fwlS.jpg',
  ];

  late Future<List<Course>> _courses;
  late Future<Profile?> _profile;
  final String defaultImageUrl = 'https://i.imgur.com/sSeFlsE.png'; // URL de la imagen por defecto

  @override
  void initState() {
    super.initState();
    _courses = CourseService().searchCourses();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      setState(() {
        _profile = ProfileService().fetchProfile(username);
      });
    } else {
      // Maneja el caso en que el nombre de usuario no esté disponible
      setState(() {
        _profile = Future.value(null);
      });
    }
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: FutureBuilder<Profile?>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cargando...', style: TextStyle(fontSize: 12)),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(defaultImageUrl),
                    ),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ubicación: Lima, Peru', style: TextStyle(fontSize: 12)),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(defaultImageUrl),
                    ),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              );
            } else {
              final profile = snapshot.data!;
              final profileImage = profile.imagePath != null
                  ? NetworkImage(profile.imagePath!)
                  : NetworkImage(defaultImageUrl) as ImageProvider;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'Ubicación: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: '${profile.city}, ${profile.country}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: CircleAvatar(
                      backgroundImage: profileImage,
                    ),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'SE PARTE DE NUESTRA COMUNIDAD VERDE',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              ImageCarousel(imgList: imgList),
              SizedBox(height: 20),
              Text(
                'Cursos Disponibles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<Course>>(
                future: _courses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay cursos disponibles'));
                  } else {
                    // Limitar el número de cursos a 4
                    final courses = snapshot.data!.take(4).toList();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.8, // Ajustar el aspect ratio
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CourseCard(
                          name: course.name,
                          price: course.price,
                          description: course.description,
                          image: course.image,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
