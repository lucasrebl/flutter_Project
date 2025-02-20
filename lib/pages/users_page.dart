import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final SupabaseService supabaseService = SupabaseService();
  List<dynamic> users = [];
  bool isLoading = true; // Ajout d'un état de chargement

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final data = await supabaseService.fetchUserData();
      setState(() {
        users = data;
        isLoading = false; // Une fois les données chargées, on arrête le chargement
      });
    } catch (e) {
      print('Erreur lors du chargement des utilisateurs : $e');
      setState(() {
        isLoading = false; // Arrête le chargement même en cas d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator()) // Affichage d'un spinner pendant le chargement
        : users.isEmpty
        ? const Center(child: Text('Aucun utilisateur trouvé.')) // Message si aucun utilisateur
        : ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user['name'] ?? 'Utilisateur inconnu'),
          subtitle: Text(user['email'] ?? 'Email inconnu'),
          leading: const Icon(Icons.person),
        );
      },
    );
  }
}
