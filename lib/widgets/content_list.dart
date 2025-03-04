import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart' as geo;
import '../services/location_service.dart';  // Importer le service de géolocalisation
import '../pages/detail_screen.dart';
import '../services/all_user_services.dart';
import '../pages/maps_page.dart';

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

  // Fonction pour charger les utilisateurs et calculer la distance
  void _loadUsers() async {
    try {
      // Récupérer les utilisateurs
      List<Map<String, dynamic>> users = await AllUserServices.getAllUsersExceptCurrent();

      // Récupérer la position actuelle de l'utilisateur via le service de géolocalisation
      geo.Position? currentPosition = await LocationService.getUserLocation();

      if (currentPosition == null) {
        print("Impossible de récupérer la position de l'utilisateur.");
        return;
      }

      // Calculer la distance pour chaque utilisateur
      List<Map<String, dynamic>> updatedUsers = users.map((user) {
        double userLat = user["latitude"] ?? 0.0;
        double userLng = user["longitude"] ?? 0.0;

        double distanceInMeters = geo.Geolocator.distanceBetween(
            currentPosition.latitude, currentPosition.longitude, // Position actuelle
            userLat, userLng // Position de l'autre utilisateur
        );

        double distanceInKm = distanceInMeters / 1000; // Conversion en km

        return {
          ...user,
          "distanceKm": distanceInKm.toStringAsFixed(1), // Arrondi à 1 décimale
        };
      }).toList();

      // Mettre à jour l'état avec les nouvelles valeurs
      setState(() {
        items = updatedUsers;
        filteredItems = List.from(updatedUsers);
      });
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    }
  }

  // Fonction pour filtrer la liste en fonction de la distance saisie
  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = List.from(items);
      });
    } else {
      setState(() {
        filteredItems = items.where((item) {
          return item["distanceKm"].toString().startsWith(query);
        }).toList();
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
