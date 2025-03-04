import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // Récupérer les données de l'utilisateur
  static Future<Map<String, dynamic>?> getUserData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    print("Données récupérées : $response"); // Debug

    return response;
  }

  // Mettre à jour les données de l'utilisateur
  static Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      print("Aucun utilisateur connecté.");
      return;
    }

    print("Données envoyées : $updatedData"); // Debug

    final response = await supabase
        .from('users')
        .update(updatedData)
        .eq('id', user.id)
        .select();

    print("Réponse de Supabase : $response"); // Debug
  }
}
