import 'package:flutter/material.dart';
import 'dart:math';
import 'package:random_name_generator/random_name_generator.dart';
import '../pages/detail_screen.dart';

class ContentList extends StatefulWidget {
  const ContentList({super.key});

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _generateItems();
  }

  void _generateItems() {
    Random random = Random();
    final randomNames = RandomNames(Zone.france);

    items = List.generate(
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
    filteredItems = List.from(items);
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(items);
      });
    } else {
      setState(() {
        filteredItems = items
            .where((item) {
          int distance = item["distanceKm"];
          return distance.toString().startsWith(query);
        })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Filtrer par distance (km)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 9.0),
                ),
                keyboardType: TextInputType.number,
                onChanged: _filterItems,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          title: filteredItems[index]["title"]!,
                          phoneNumber: filteredItems[index]["phoneNumber"]!,
                          imageUrl: filteredItems[index]["imageUrl"]!,
                          distanceKm: filteredItems[index]["distanceKm"].toString(),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(filteredItems[index]["imageUrl"]!),
                      ),
                      title: Text(
                        filteredItems[index]["title"]!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "📞 ${filteredItems[index]["phoneNumber"]!}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      trailing: Text(
                        "${filteredItems[index]["distanceKm"]} km",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredItems.length,
            ),
          ),
        ],
      ),
    );
  }
}
