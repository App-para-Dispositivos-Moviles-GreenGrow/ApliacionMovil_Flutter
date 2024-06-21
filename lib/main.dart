import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'models/cart_model.dart';
import 'providers/article_provider.dart';
import 'screens/articles_page.dart';
import 'screens/home_page.dart';
import 'screens/courses_page.dart';
import 'screens/community_page.dart';
import 'screens/profile_page.dart';
import 'screens/cart_page.dart';
import 'screens/login.dart';
import 'screens/register_screen.dart';
import 'screens/start_screen.dart';
import 'screens/community/postscreen.dart';

void main() {
  runApp(GreenGrowApp());
}

class GreenGrowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
        ChangeNotifierProvider(create: (context) => CartModel()),
      ],
      child: MaterialApp(
        title: 'GreenGrow App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/', // Inicia con la pantalla de inicio
        routes: {
          '/': (context) => ScreenStart(), // Define la ruta para la pantalla de inicio
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
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
              ),
              GButton(
                icon: Icons.book,
              ),
              GButton(
                icon: Icons.file_open,
              ),
              GButton(
                icon: Icons.supervisor_account,
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
