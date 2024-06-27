import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/services/cart_service.dart';
import 'package:flutter_application_1/session/user_session.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.totalPrice});
  final int totalPrice;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;
  bool paymentProcessed = false;

  final CartService cartService = CartService();

  void _processPayment() async {
    setState(() {
      isProcessing = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isProcessing = false;
      paymentProcessed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Método de pago',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.credit_card),
                              SizedBox(width: 10),
                              Text('Tarjeta de crédito/débito'),
                            ],
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Número de tarjeta'),
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'Fecha de vencimiento'),
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: 'CVV'),
                          ),
                          SizedBox(height: 20),
                          
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Resumen',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Precio original'),
                      Text('S/${widget.totalPrice}.00'),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Descuentos'),
                      Text('- S/0.00'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'S/${widget.totalPrice}.00',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        _processPayment();
                        await Future.delayed(const Duration(seconds: 1));
                        cartService.processShoppingCart(UserSession.username);
                        showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: const Text(
                              'Pago realizado con éxito',
                              style: TextStyle(fontSize: 16),
                              ),
                            icon: const Icon(
                              Icons.check,
                              color: Colors.green,),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                  ));
                                },  
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.green)),
                                child: const Center(
                                  child: Text(
                                    'Volver al menú',
                                    style: TextStyle(color: Colors.white),),
                                ),
                                )
                            ],
                          )
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      child: isProcessing ? 
                      const CircularProgressIndicator()
                      : const Text('Comprar ahora', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}