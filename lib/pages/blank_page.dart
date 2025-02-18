import 'package:flutter/material.dart';

class BlankPage extends StatelessWidget {
  final String title;

  const BlankPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
