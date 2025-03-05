import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class DetailScreen extends StatelessWidget {
  final String title;
  final String phoneNumber;
  final String imageUrl;
  final String distanceKm;
  final String email;
  final String description;
  final int age;
  final String profession;
  final double latitude;
  final double longitude;
  final String userId;

  const DetailScreen({
    super.key,
    required this.title,
    required this.phoneNumber,
    required this.imageUrl,
    required this.distanceKm,
    required this.email,
    required this.description,
    required this.age,
    required this.profession,
    required this.latitude,
    required this.longitude,
    required this.userId,  // Ajout de l'identifiant de l'utilisateur
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final isFavorite = userProvider.isFavorite(userId);  // Vérification de l'état favori

    return Scaffold(
      appBar: AppBar(title: const Text("Détails")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),

            // Affichage de l'image de l'utilisateur
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl.isEmpty
                            ? "https://picsum.photos/200/300?random"
                            : imageUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Affichage des autres informations utilisateur
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("📞 $phoneNumber", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Email : $email", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Profession : $profession", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Age : $age ans", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Description : $description", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Distance : $distanceKm km", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),

                    // Bouton favori
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        userProvider.toggleFavorite(userId);  // Action sur le favori
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
