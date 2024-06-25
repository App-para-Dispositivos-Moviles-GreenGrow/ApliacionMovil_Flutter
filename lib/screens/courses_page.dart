import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/screens/detailed_course.dart';
import 'package:flutter_application_1/services/cart_service.dart';
import 'package:flutter_application_1/services/courses_service.dart';
import 'package:flutter_application_1/screens/add_course_page.dart';
import 'package:flutter_application_1/session/user_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> courses = [];
  final CourseService courseService = CourseService();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      final fetchedCourses = await courseService.searchCourses();
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      print('Error al cargar los cursos: $e');
    }
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cursos"),
        actions: [
          FutureBuilder<String>(
            future: _getUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Mostrar un indicador de carga mientras se obtiene el nombre de usuario
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(); // Manejar error o caso en que no haya nombre de usuario
              }
              String username = snapshot.data!;
              return FutureBuilder<String>(
                future: CourseService().getUserRole(username),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // Mostrar un indicador de carga mientras se obtiene el rol
                  }
                  if (roleSnapshot.hasError) {
                    print("Error obteniendo el rol del usuario: ${roleSnapshot.error}");
                    return Container(); // Manejar error
                  }
                  print("Rol del usuario recibido: ${roleSnapshot.data}");
                  if (roleSnapshot.data == "experto") {
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 89, 4),
                      ),
                      onPressed: () async {
                        // Esperar el resultado de AddCoursePage
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCoursePage(onCourseAdded: initialize),
                          ),
                        );
                        if (result == true) {
                          // Recargar los cursos si se añadió un nuevo curso
                          initialize();
                        }
                      },
                      child: const Text(
                        'Agregar curso',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return Container(); // No mostrar el botón si el rol no es "experto"
                },
              );
            },
          ),
        ],
      ),
      body: CoursesList(courses: courses),
    );
  }
}

class CoursesList extends StatelessWidget {
  CoursesList({super.key, required this.courses});

  final List<Course> courses;
  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      shrinkWrap: true,
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return CourseItem(course: courses[index], cartService: cartService,);
      },
    );
  }
}

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.course, required this.cartService});
  final Course course;
  final CartService cartService;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailed(course: course)));
        },
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                course.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              course.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              course.description,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${course.price.toString()}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    IconButton(onPressed: () {
                        // Acción a realizar cuando se presiona el botón
                        //cartService.addCourseToShoppintCart(UserSession.username, course.id!);
                        showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Está a punto de añadir este curso al carrito de compras',
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  cartService.addCourseToShoppintCart(UserSession.username, course.id!);
                                  Navigator.pop(context);
                                }, 
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                                child: const Center(
                                  child: Text('Aceptar',
                                  style: TextStyle(color: Colors.white),),
                                ))
                            ],
                          ));
                      }, 
                      icon: const Icon(Icons.add, color: Colors.green,))
                  ], 
                ),
          ),
        ],
      ),
      ),
    );
  }
}
