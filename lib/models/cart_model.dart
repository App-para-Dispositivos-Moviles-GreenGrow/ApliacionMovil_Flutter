import 'package:flutter/material.dart';
import 'course.dart';

class CartModel extends ChangeNotifier {
  final List<Course> _items = [];

  List<Course> get items => _items;

  double get totalPrice => _items.fold(0, (total, current) => total + current.price);

  void add(Course course) {
    _items.add(course);
    notifyListeners();
  }

  void remove(Course course) {
    _items.remove(course);
    notifyListeners();
  }
}
