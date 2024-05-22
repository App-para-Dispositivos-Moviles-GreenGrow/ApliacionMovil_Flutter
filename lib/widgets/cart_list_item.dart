import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../models/cart_model.dart';

class CartListItem extends StatelessWidget {
  final Course course;

  CartListItem({required this.course});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);

    return ListTile(
      title: Text(course.name),
      subtitle: Text('\$${course.price.toStringAsFixed(2)}'),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle_outline),
        onPressed: () {
          cart.remove(course);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${course.name} removed from cart'),
          ));
        },
      ),
    );
  }
}
