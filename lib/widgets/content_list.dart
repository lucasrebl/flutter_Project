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
  bool _isFavoriteFilter = false;
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    // Charger les utilisateurs après le build initial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUsers().then((_) {
        setState(() {
          _filteredUsers = userProvider.users;
        });
      });
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      // Appliquer la recherche sur la liste actuelle filtrée (par favoris ou non)
      _filteredUsers = userProvider.users.where((user) {
        final name = user["name"] ?? "";
        return name.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();

      // Appliquer également le filtre des favoris après la recherche
      if (_isFavoriteFilter) {
        _filteredUsers = _filteredUsers
            .where((user) => userProvider.isFavorite(user["id"]))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Utilisateurs"),
        actions: [
          IconButton(
            icon: Icon(_isFavoriteFilter ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavoriteFilter = !_isFavoriteFilter;
                // Appliquer ou supprimer le filtre des favoris
                if (_isFavoriteFilter) {
                  _filteredUsers = userProvider.users
                      .where((user) => userProvider.isFavorite(user["id"]))
                      .toList();
                } else {
                  _filteredUsers = userProvider.users;
                }
                // Appliquer la recherche après avoir filtré les favoris
                _onSearchChanged();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Rechercher par nom",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final user = _filteredUsers[index];
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
                                imageUrl: user["avatar_url"] ?? "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
                                distanceKm: user["distanceKm"].toString(),
                                email: user["email"] ?? "Email non disponible",
                                description: user["description"] ?? "Pas de description",
                                age: user["age"] ?? 0,
                                profession: user["profession"] ?? "Inconnu",
                                latitude: user["latitude"] ?? 0.0,
                                longitude: user["longitude"] ?? 0.0,
                                userId: user["id"],
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
                                user["avatar_url"] ?? "https://picsum.photos/200/300?random=${Random().nextInt(1000)}",
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
                    childCount: _filteredUsers.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
