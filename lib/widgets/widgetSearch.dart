import 'package:flutter/material.dart';

class Widgetsearch extends StatelessWidget {
  const Widgetsearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: "Buscar ...",
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}