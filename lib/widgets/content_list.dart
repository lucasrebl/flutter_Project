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
  @override
  void initState() {
    super.initState();

    // Charger les utilisateurs après le build initial
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
                final user = userProvider.users[index];
                final userId = user["id"];
                final isFavorite = userProvider.isFavorite(userId);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          title: user["name"] ?? "Nom inconnu",
                          phoneNumber: user["phone_number"] ?? "Numéro non disponible",
                          imageUrl: user["avatar_url"] ??
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
                          distanceKm: user["distanceKm"].toString(),
                          email: user["email"] ?? "Email non disponible",
                          description: user["description"] ?? "Pas de description",
                          age: user["age"] ?? 0,
                          profession: user["profession"] ?? "Inconnu",
                          latitude: user["latitude"] ?? 0.0,
                          longitude: user["longitude"] ?? 0.0,
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
                          user["avatar_url"] ??
                              "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
                        ),
                      ),
                      title: Text(
                        user["name"] ?? "Nom inconnu",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "📞 ${user["phone_number"] ?? "Numéro non disponible"}",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${user["distanceKm"]} km",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              userProvider.toggleFavorite(userId);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: userProvider.users.length,
            ),
          ),
        ],
      ),
    );
  }
}
