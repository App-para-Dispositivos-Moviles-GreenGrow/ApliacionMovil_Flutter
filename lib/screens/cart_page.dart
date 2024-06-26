import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/course.dart';
import 'package:flutter_application_1/screens/payment_page.dart';
import 'package:flutter_application_1/services/cart_service.dart';
import 'package:flutter_application_1/session/user_session.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Course> courses = [];
  bool isLoading = true;
  final CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final fetchedCourses = await cartService.getShoppingCart(UserSession.username);
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeCourse(int id) async {
    try {
      await cartService.deleteCourseFromShoppingCart(UserSession.username, id);
      //final fetchedCourses = await cartService.getShoppingCart(UserSession.username); 
      setState(() {
        courses.removeWhere((course) => course.id == id);
      });
    } catch (error) {
      // Manejar el error de acuerdo a tus necesidades
    }
  }

  int _calculateTotalPrice() {
    return courses.fold(0, (total, course) => total + course.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return ListTile(
                        leading: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 90,
                            minWidth: 90 // Limita el ancho de la imagen
                          ),
                          child: Image.network(course.image, fit: BoxFit.cover),
                        ),
                        title: Text(course.name),
                        subtitle: Text('S/${course.price}\n${course.description}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeCourse(course.id!);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: S/${_calculateTotalPrice()}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Acción al presionar el botón "Comprar"
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(totalPrice: _calculateTotalPrice()),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Color del botón
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Tamaño más grande
                          textStyle: const TextStyle(fontSize: 20), // Texto más grande
                        ),
                        child: const Text('Comprar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
