import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    final data = await UserService.getUserData();
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void _showEditDialog() {
    if (userData == null) return;

    TextEditingController nameController = TextEditingController(text: userData!['name'] ?? '');
    TextEditingController phoneController = TextEditingController(text: userData!['phone_number'] ?? '');
    TextEditingController ageController = TextEditingController(text: userData!['age']?.toString() ?? '');
    TextEditingController professionController = TextEditingController(text: userData!['profession'] ?? '');
    TextEditingController descriptionController = TextEditingController(text: userData!['description'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier le profil"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: "Nom")),
                TextField(controller: phoneController, decoration: InputDecoration(labelText: "Téléphone")),
                TextField(controller: ageController, decoration: InputDecoration(labelText: "Âge"), keyboardType: TextInputType.number),
                TextField(controller: professionController, decoration: InputDecoration(labelText: "Profession")),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
            ElevatedButton(
              onPressed: () async {
                // Mettre à jour l'utilisateur
                await UserService.updateUserData({
                  "name": nameController.text,
                  "phone_number": phoneController.text,
                  "age": int.tryParse(ageController.text) ?? 0,
                  "profession": professionController.text,
                  "description": descriptionController.text,
                });

                // Rafraîchir les données
                fetchUserData();
                Navigator.pop(context);
              },
              child: Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(userData!['avatar_url'] ?? "https://picsum.photos/200"),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(userData!['name'] ?? 'Nom non disponible', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("Âge : ${userData!['age'] ?? 'Inconnu'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text("Métier : ${userData!['profession'] ?? 'Non défini'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text("Téléphone : ${userData!['phone_number'] ?? 'Aucun numéro'}", style: TextStyle(fontSize: 18)),
                SizedBox(height: 8),
                Text("Description : ${userData!['description'] ?? 'Aucune description'}", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
