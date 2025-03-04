import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class AllUserServices {
  // Fonction pour récupérer les informations de tous les utilisateurs sauf l'utilisateur connecté
  static Future<List<Map<String, dynamic>>> getAllUsersExceptCurrent() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        // Récupérer les données de tous les utilisateurs sauf celui connecté
        final response = await supabase
            .from('users')
            .select()
            .neq('id', userId) // Exclure l'utilisateur connecté
            .order('created_at', ascending: false); // Optionnel : ordonner les résultats par date de création (descendant)

        if (response != null) {
          return List<Map<String, dynamic>>.from(response);  // Retourner les données des utilisateurs
        } else {
          print("Aucun autre utilisateur trouvé");
          return [];
        }
      } else {
        print("Utilisateur non connecté");
        return [];
      }
    } catch (e) {
      print("Erreur lors de la récupération des utilisateurs : $e");
      return [];
    }
  }
}
