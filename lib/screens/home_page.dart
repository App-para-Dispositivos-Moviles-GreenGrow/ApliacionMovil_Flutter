import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de tener esta dependencia
import '../widgets/course_card.dart';
import '../widgets/image_carousel.dart';
import '../services/courses_service.dart';
import '../services/profile_service.dart';
import '../models/profile.dart'; // Importa el modelo de perfil
import '../models/course.dart'; // Importa el modelo de curso
import 'profile_page.dart';  // Importa la página de perfil
import 'articles_page.dart';  // Importa la página de Artículos
import 'courses_page.dart';  // Importa la página de Cursos
import 'community/postscreen.dart';  // Importa la página de Comunidad

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'assets/images/imagen1.png',
    'assets/images/imagen2.png',
    'assets/images/imagen3.png',
    'assets/images/imagen4.png',
  ];

  late Future<List<Course>> _courses;
  late Future<Profile?> _profile;
  final String defaultImageUrl = 'assets/images/imagenR.png'; // Ruta a la imagen por defecto

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

  void _navigateToPage(BuildContext context, String title) {
    Widget page;
    switch (title) {
      case 'Cursos':
        page = CoursesPage();
        break;
      case 'Comunidad':
        page = PostScreen();  // Cambia aquí a PostScreen
        break;
      case 'Artículos':
        page = ArticlesPage();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
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
                      backgroundImage: AssetImage(defaultImageUrl),
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
                      backgroundImage: AssetImage(defaultImageUrl),
                    ),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              );
            } else {
              final profile = snapshot.data!;
              final profileImage = profile.imagePath != null
                  ? NetworkImage(profile.imagePath!)
                  : AssetImage(defaultImageUrl) as ImageProvider;
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
              Center(
                child: Text(
                  'Cursos Más Destacados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
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
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Nuestros Servicios',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildServiceCard(
                      context,
                      'Cursos',
                      'assets/images/cursos.png',
                    ),
                    SizedBox(width: 10),
                    _buildServiceCard(
                      context,
                      'Comunidad',
                      'assets/images/comunidad.png',
                    ),
                    SizedBox(width: 10),
                    _buildServiceCard(
                      context,
                      'Artículos',
                      'assets/images/articulos.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String imageUrl) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, title),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
            children: [
              Image.asset(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Centrar el texto
              ),
            ],
          ),
        ),
      ),
    );
  }
}

