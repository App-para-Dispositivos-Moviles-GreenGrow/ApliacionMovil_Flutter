import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/community/postscreen.dart';
import 'package:flutter_application_1/screens/start_screen.dart';
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
import '/services/user_service.dart';  // Asegúrate de que la ruta sea correcta

void main() {
  runApp(GreenGrowApp());
}

class GreenGrowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ArticleProvider()),
      ],
      child: MaterialApp(
        title: 'GreenGrow App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        //home: LoginScreen(), // Inicia con LoginScreen
        home: ScreenStart(), // Inicia con MainScreen
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
  int _selectedIndex = 0;  // Empezamos mostrando la HomePage

  static List<Widget> _pages = <Widget>[
    HomePage(),
    CoursesPage(),
    ArticlesPage(),

    PostScreen(),

    ProfilePage(),  // Asegúrate de que estas páginas estén definidas
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
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
