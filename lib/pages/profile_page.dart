import 'package:flutter/material.dart';
import '../services/user_service.dart';// Importer le service UserService

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserService.getUserData(),  // Utiliser UserService pour récupérer les données
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Afficher un indicateur de chargement
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Aucune donnée trouvée"));
          }

          final userData = snapshot.data!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userData['avatar_url'] ?? "https://picsum.photos/200"),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(userData['name'] ?? 'Nom non disponible', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Age : ${userData['age'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text("Métier : ${userData['profession'] ?? 'Non défini'}", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text("Description : ${userData['description'] ?? 'Aucune description'}", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
