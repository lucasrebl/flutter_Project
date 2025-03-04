import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabase = Supabase.instance.client;

class UserService {
  // Fonction pour récupérer les informations de l'utilisateur connecté
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        // Récupérer les données de l'utilisateur à partir de la table `users`
        final response = await supabase
            .from('users')
            .select()
            .eq('id', userId)
            .maybeSingle();  // On utilise maybeSingle() pour récupérer un seul résultat

        if (response != null) {
          return response;  // Retourner les données de l'utilisateur
        } else {
          print("Aucun utilisateur trouvé avec cet ID");
          return null;
        }
      } else {
        print("Utilisateur non connecté");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération des données de l'utilisateur : $e");
      return null;
    }
  }
}
