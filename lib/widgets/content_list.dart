import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../pages/detail_screen.dart';
import 'dart:math';

class ContentList extends StatefulWidget {
  const ContentList({super.key});

  @override
  _ContentListState createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();

    // Use addPostFrameCallback to load users after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUsers();
    });
  }

  void _filterItems(String query) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(userProvider.users);
      });
    } else {
      setState(() {
        filteredItems = userProvider.users.where((item) {
          return item["distanceKm"].toString().startsWith(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    filteredItems = userProvider.users;

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
                          title: filteredItems[index]["name"] ?? "Nom inconnu",
                          phoneNumber: filteredItems[index]["phone_number"] ?? "Numéro non disponible",
                          imageUrl: filteredItems[index]["avatar_url"] ??
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
                          distanceKm: filteredItems[index]["distanceKm"].toString(),
                          email: filteredItems[index]["email"] ?? "Email non disponible",
                          description: filteredItems[index]["description"] ?? "Pas de description",
                          age: filteredItems[index]["age"] ?? 0,
                          profession: filteredItems[index]["profession"] ?? "Inconnu",
                          latitude: filteredItems[index]["latitude"] ?? 0.0,
                          longitude: filteredItems[index]["longitude"] ?? 0.0,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          filteredItems[index]["avatar_url"] ??
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
                        ),
                      ),
                      title: Text(
                        filteredItems[index]["name"] ?? "Nom inconnu",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "📞 ${filteredItems[index]["phone_number"] ?? "Numéro non disponible"}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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