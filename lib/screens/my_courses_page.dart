import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/screens/buyed_detailed_course_page.dart';
import 'package:flutter_application_1/services/courses_service.dart';
import 'package:flutter_application_1/session/user_session.dart';
import 'package:flutter_application_1/widgets/course_card.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  List<Course> courses = [];
  final CourseService courseService = CourseService();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    try {
      final fetchedCourses = await courseService.getBuyedCourses(UserSession.username);
      setState(() {
        courses = fetchedCourses;
      });
    } catch (e) {
      //print error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mis cursos")),
        body: MyCourseList(courses: courses),
    );
  }
}

class MyCourseList extends StatelessWidget {
  const MyCourseList({super.key, required this.courses});
  final List<Course> courses;
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
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyBuyedCourse(course: courses[index])));
          },
          child: CourseCard(
          name: courses[index].name, 
          price: courses[index].price, 
          description: courses[index].description, 
          image: courses[index].image));
      },
    );
  }
}