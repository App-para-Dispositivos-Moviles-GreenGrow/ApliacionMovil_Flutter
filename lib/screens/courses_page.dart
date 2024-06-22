import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/services/courses_service.dart';
import 'package:flutter_application_1/screens/add_course_page.dart';
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
        title: const Text("Courses"),
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
                    return IconButton(
                      icon: const Icon(Icons.add),
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
  const CoursesList({super.key, required this.courses});

  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        return CourseItem(course: courses[index]);
      },
    );
  }
}

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(
                course.image,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Icon(Icons.broken_image);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 113, 4)),
                ),
                Text(
                  course.description,
                  style: const TextStyle(color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${course.price}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    const Icon(
                      Icons.add,
                      color: Colors.green,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
