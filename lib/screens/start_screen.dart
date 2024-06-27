import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';

class ScreenStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/imagenF.jpg', // Cambia esto al nombre de tu imagen
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Aprende y crece\ncon nuestros\ncursos online de\nagricultura',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Conocimiento superior desde la raíz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 300.0,
                height: 60.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF224F34),
                  ),
                  child: Text(
                    'Empezar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}