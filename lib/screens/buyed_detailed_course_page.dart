import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBuyedCourse extends StatelessWidget {
  const MyBuyedCourse({super.key, required this.course});

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
          children: [
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
            TextButton(
              onPressed: () {
                _launchURL(course.videoUrl);
              }, 
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
              child: const Center(child: Text('Accede a tu curso',
                style: TextStyle(color: Colors.white)),))
          ],
        ),
      ),
    );
  }
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch url";
    }
  }
}