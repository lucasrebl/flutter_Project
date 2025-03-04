import 'package:flutter/material.dart';
import 'dart:math';
import '../pages/detail_screen.dart';
import '../services/all_user_services.dart';  // Assurez-vous d'importer votre service

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
    _loadUsers();
  }

  // Fonction pour charger les utilisateurs depuis Supabase
  void _loadUsers() async {
    try {
      List<Map<String, dynamic>> users = await AllUserServices.getAllUsersExceptCurrent();
      setState(() {
        items = users;
        filteredItems = List.from(users);
      });
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    }
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
                          title: filteredItems[index]["name"] ?? "Nom inconnu",
                          phoneNumber: filteredItems[index]["phone_number"] ?? "Numéro non disponible",
                          imageUrl: filteredItems[index]["avatar_url"] ??
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}", // Générer une image si l'URL est vide
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
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}", // Générer une image si l'URL est vide
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
                      //trailing: Text(
                        //"${filteredItems[index]["distanceKm"]} km",
                        //style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                      //),
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
