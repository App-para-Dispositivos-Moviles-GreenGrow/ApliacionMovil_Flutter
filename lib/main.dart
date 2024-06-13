import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/screens/community/postscreen.dart';
import 'package:flutter_application_1/screens/start_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'providers/article_provider.dart';
import 'screens/articles_page.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/community_page.dart';
import 'screens/profile_page.dart';
import 'screens/cart_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/login.dart';
import '/services/user_service.dart'; // Asegúrate de que la ruta sea correcta

void main() {
  runApp(GreenGrowApp());
}

class GreenGrowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(create: (context) => CartModel()), // Agrega CartModel aquí
      ],
      child: MaterialApp(
        title: 'GreenGrow App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: ScreenStart(), // Inicia con ScreenStart
        routes: {
          '/home': (context) => MainScreen(), // Define ruta para MainScreen
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Empezamos mostrando la HomePage

  final _pages = [
    HomePage(),
    CoursesPage(),
    ArticlesPage(),
    PostScreen(),
    ProfilePage(),
    CartPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GreenGrow App'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xFF267144).withOpacity(0.5),
            gap: 8,
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.book,
                text: 'Cursos',
              ),
              GButton(
                icon: Icons.file_open,
                text: 'Artículos',
              ),
              GButton(
                icon: Icons.supervisor_account,
                text: 'Comunidad',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('GreenGrow Menu'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Cart'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
