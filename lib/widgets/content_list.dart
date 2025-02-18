import 'package:flutter/material.dart';
import 'dart:math';
import 'package:random_name_generator/random_name_generator.dart';
import '../pages/detail_screen.dart';

class ContentList extends StatelessWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    final randomNames = RandomNames(Zone.france);

    List<Map<String, dynamic>> items = List.generate(
      10,
          (index) {
        int distance = random.nextInt(50) + 1;
        String phoneNumber = "07${random.nextInt(100000000).toString().padLeft(8, '0')}";
        String randomName = randomNames.fullName();

        return {
          "title": randomName,
          "phoneNumber": phoneNumber,
          "imageUrl": "https://picsum.photos/200/300?random=${index + 1}",
          "distanceKm": distance,
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
                  phoneNumber: items[index]["phoneNumber"]!,
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
                items[index]["title"]!,
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
