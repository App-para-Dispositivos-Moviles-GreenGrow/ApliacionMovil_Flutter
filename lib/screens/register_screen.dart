import 'package:flutter/material.dart';
import '../services/register_user_service.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // Controlador para la URL de la imagen
  final RegisterUserService _userService = RegisterUserService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _selectedRole = 'usuario'; // Valor inicial para el rol

  final List<String> roles = ['usuario', 'experto']; // Lista de roles

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
            'assets/images/imagenF.jpg', // Cambia esto al nombre de tu imagen
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0), // Espaciado superior e inferior
              child: Center(
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
                          Image.network(
                            'https://i.imgur.com/r286Yq3.png', // URL del logo
                            width: 70,
                            height: 70,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Crea una cuenta',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextField(controller: _dniController, label: 'DNI'),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Rol',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            items: roles.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(controller: _firstNameController, label: 'Nombres'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _lastNameController, label: 'Apellidos'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _emailController, label: 'Correo electrónico'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _usernameController, label: 'Nombre de usuario'),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Contraseña',
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            togglePasswordVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _confirmPasswordController,
                            label: 'Confirmar contraseña',
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            togglePasswordVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(controller: _countryController, label: 'País'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _cityController, label: 'Ciudad'),
                          SizedBox(height: 20),
                          CustomTextField(controller: _imageUrlController, label: 'URL de la imagen (opcional)'), // Nuevo campo para la URL de la imagen
                          SizedBox(height: 20),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _register,
                                  child: Text(
                                    'Registrarte',
                                    style: TextStyle(color: Colors.white), // Cambiar el color del texto a blanco
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Cambiar el color de fondo del botón
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _register() async {
    final dni = _dniController.text;
    final role = _selectedRole; // Utilizar el valor seleccionado del Dropdown
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final country = _countryController.text;
    final city = _cityController.text;
    final imageUrl = _imageUrlController.text; // Obtener el valor de la URL de la imagen

    // Validar que los campos no estén vacíos
    if (dni.isEmpty || role.isEmpty || firstName.isEmpty || lastName.isEmpty || email.isEmpty ||
        username.isEmpty || password.isEmpty || confirmPassword.isEmpty || country.isEmpty || city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Validar que las contraseñas coincidan
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isRegistered = await _userService.register(
        dni, role, firstName, lastName, email, username, password, country, city, imageUrl,
      );

      if (isRegistered) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro fallido. Inténtalo de nuevo.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
