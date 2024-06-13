import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/services/courses_service.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Courses"),
      ),
      body: const CoursesList()
    );
  }
}

class CoursesList extends StatefulWidget {
  const CoursesList({super.key});

  @override
  State<CoursesList> createState() => _CoursesListState();
}

class _CoursesListState extends State<CoursesList> {
  List courses = [];
  final CourseService courseService = CourseService();

  initialize() async{
    courses = await courseService.searchCourses();
    setState(() {
      courses = courses;
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
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
      itemBuilder:(context, index) {
        return CourseItem(course: courses[index]);
      },);
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
                course?.image  ?? '', errorBuilder: (
                  BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Icon(Icons.broken_image);
              },
              ),
            ),
          ),
          Column(
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
          )
        ],
      ),
    );
  }
}