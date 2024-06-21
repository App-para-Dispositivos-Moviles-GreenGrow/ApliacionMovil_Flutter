import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile?> _profileFuture;
  ProfileService _profileService = ProfileService();
  TextEditingController _imageUrlController = TextEditingController();
  bool _isEditingImageUrl = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');  // Asegúrate de guardar el nombre de usuario al iniciar sesión
    print('Username: $username');
    if (username != null) {
      setState(() {
        _profileFuture = _profileService.fetchProfile(username);
      });
    } else {
      // Maneja el caso en que el nombre de usuario no esté disponible
      setState(() {
        _profileFuture = Future.value(null);
      });
    }
  }

  Future<void> _updateImageUrl() async {
    final imageUrl = _imageUrlController.text;
    if (imageUrl.isNotEmpty) {
      final profile = await _profileFuture;
      if (profile != null) {
        final updatedProfile = Profile(
          dni: profile.dni,
          role: profile.role,
          firstName: profile.firstName,
          lastName: profile.lastName,
          email: profile.email,
          country: profile.country,
          city: profile.city,
          imagePath: imageUrl,
        );

        await _profileService.updateProfile(updatedProfile);
        setState(() {
          _profileFuture = Future.value(updatedProfile);
          _isEditingImageUrl = false; // Ocultar el campo de texto después de actualizar
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.green,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: FutureBuilder<Profile?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    print('No data');
                    return Center(child: Text('No se pudo cargar el perfil'));
                  } else {
                    final profile = snapshot.data!;
                    print('Profile loaded: ${profile.toJson()}');
                    _imageUrlController.text = profile.imagePath ?? '';
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: profile.imagePath != null ? NetworkImage(profile.imagePath!) : null,
                                child: profile.imagePath == null ? Icon(Icons.person, size: 50) : null,
                              ),
                              SizedBox(height: 16),
                              if (_isEditingImageUrl)
                                Column(
                                  children: [
                                    TextField(
                                      controller: _imageUrlController,
                                      decoration: InputDecoration(
                                        labelText: 'URL de la Imagen',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _updateImageUrl,
                                      child: Text('Guardar Imagen', style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              if (!_isEditingImageUrl)
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingImageUrl = true;
                                    });
                                  },
                                  child: Text('Actualizar Imagen', style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  ),
                                ),
                              SizedBox(height: 24),
                              _buildProfileInfo('DNI', profile.dni),
                              _buildProfileInfo('Rol', profile.role),
                              _buildProfileInfo('Nombres', profile.firstName),
                              _buildProfileInfo('Apellidos', profile.lastName),
                              _buildProfileInfo('Correo', profile.email),
                              _buildProfileInfo('País', profile.country),
                              _buildProfileInfo('Ciudad', profile.city),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
