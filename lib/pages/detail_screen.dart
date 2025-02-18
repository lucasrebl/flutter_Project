import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String description; // Maintenant, il contiendra le numéro de téléphone
  final String imageUrl;
  final String distanceKm;

  const DetailScreen({super.key, required this.title, required this.description, required this.imageUrl, required this.distanceKm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("📞 $description", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)), // Numéro en vert
                const SizedBox(height: 8),
                Text("Distance : $distanceKm km", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
