import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';

class CourseDetailed extends StatelessWidget {
  const CourseDetailed({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Image.network(course.image),
            SizedBox(height: 16.0),
            Text(
              course.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              course.description,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$${course.price}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            //ElevatedButton(
            //  onPressed: () {
                // Acción al presionar el botón (puede ser reproducir un video, comprar el curso, etc.)
            //    print('Comprar el curso');
            //  },
            //  child: Text('Comprar'),
            //),
          ],
        ),
      ),
    );
  }
}