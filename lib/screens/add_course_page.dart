import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/services/courses_service.dart';

class AddCoursePage extends StatelessWidget {
  final VoidCallback onCourseAdded;

  const AddCoursePage({super.key, required this.onCourseAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController videoUrlController = TextEditingController();

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
            TextField(
              controller: videoUrlController,
              decoration: const InputDecoration(labelText: 'Video URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final course = Course(
                  name: nameController.text,
                  price: int.parse(priceController.text),
                  description: descriptionController.text,
                  image: imageController.text,
                  videoUrl: videoUrlController.text,
                );

                final CourseService courseService = CourseService();
                try {
                  await courseService.addCourse(course);
                  onCourseAdded(); // Llama a la función para actualizar la lista de cursos
                  Navigator.pop(context, true); // Devuelve true si se añadió un curso
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Curso añadido con éxito')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al añadir el curso: $e')),
                  );
                }
              },
              child: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}

