import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Mon App",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: const ContentList(),
      ),
    );
  }
}

class ContentList extends StatelessWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = List.generate(
      10,
          (index) => {
        "title": "Nom ${index + 1}",
        "description": "Description ${index + 1}.",
        "imageUrl": "https://picsum.photos/200/300${index + 1}"
      },
    );

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(items[index]["imageUrl"]!),
            ),
            title: Text(
              items[index]["title"]!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              items[index]["description"]!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            onTap: () {
            },
          ),
        );
      },
    );
  }
}
