import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar SharedPreferences
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final String logoPath = 'assets/images/logo.png'; // Ruta del logo
  final String backgroundPath = 'assets/images/imagenF.jpg'; // Ruta del fondo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundPath,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        logoPath,
                        width: 70,
                        height: 70,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _login,
                              child: Text(
                                'Iniciar sesión',
                                style: TextStyle(color: Colors.white), // Cambiar el texto a blanco
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // Color de fondo del botón
                              ),
                            ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register'); // Redirigir a la pantalla de registro
                            },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Validar que los campos no estén vacíos
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final isAuthenticated = await _userService.authenticate(username, password);

    setState(() {
      _isLoading = false;
    });

    if (isAuthenticated) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username); // Guardar el nombre de usuario
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }
}
