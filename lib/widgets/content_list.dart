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
  // Nous n'avons plus besoin de la variable de filtrage.
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();

    // Utilisation de addPostFrameCallback pour charger les utilisateurs après le build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Initialiser filteredItems avec tous les utilisateurs disponibles
    filteredItems = userProvider.users;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Utilisateurs", style: TextStyle(fontSize: 20)),
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
