import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/services/courses_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddCoursePage(),
                          ),
                        );
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
      body: const CoursesList(),
    );
  }
}

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  List<Course> courses = [];
  final CourseService courseService = CourseService();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    try {
      final fetchedCourses = await courseService.searchCourses();
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      // Manejo de errores (por ejemplo, mostrar un mensaje de error en la interfaz de usuario)
      print('Error al cargar los cursos: $e');
    }
  }

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
                errorBuilder: (
                  BuildContext context, Object exception, StackTrace? stackTrace) {
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
                      color: Colors.green
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

class AddCoursePage extends StatelessWidget {
  const AddCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final course = Course(
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  description: descriptionController.text,
                  image: imageController.text,
                );

                final CourseService courseService = CourseService();
                await courseService.addCourse(course);

                Navigator.pop(context);
              },
              child: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}
