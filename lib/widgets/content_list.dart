import 'package:flutter/material.dart';
import 'dart:math';
import 'package:random_name_generator/random_name_generator.dart'; // Import du package
import '../pages/detail_screen.dart';

class ContentList extends StatelessWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomNames = RandomNames(Zone.us); // Générateur de noms

    List<Map<String, dynamic>> items = List.generate(
      10,
          (index) {
        int distance = random.nextInt(50) + 1;
        String phoneNumber = "06${random.nextInt(100000000).toString().padLeft(8, '0')}";
        String randomName = randomNames.fullName(); // Génère un nom complet

        return {
          "title": randomName, // Utilisation du nom aléatoire généré
          "phoneNumber": phoneNumber, // Numéro de téléphone
          "imageUrl": "https://picsum.photos/200/300?random=${index + 1}",
          "distanceKm": distance, // Distance stockée séparément
        };
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  title: items[index]["title"]!,
                  description: items[index]["phoneNumber"]!,
                  imageUrl: items[index]["imageUrl"]!,
                  distanceKm: items[index]["distanceKm"].toString(),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(items[index]["imageUrl"]!),
              ),
              title: Text(
                items[index]["title"]!, // Nom généré aléatoirement
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "📞 ${items[index]["phoneNumber"]!}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              trailing: Text(
                "${items[index]["distanceKm"]} km",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}
