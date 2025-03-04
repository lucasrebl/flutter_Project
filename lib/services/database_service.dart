import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

final SupabaseClient supabase = Supabase.instance.client;

class DatabaseService {
  // Fonction pour insérer un utilisateur s'il n'existe pas
  static Future<void> insertUserIfNotExists(User user) async {
    try {
      // Vérifier si l'email est nul avant de faire la requête
      if (user.email != null) {
        // Vérifie si un utilisateur avec le même email existe déjà
        final existingUser = await supabase
            .from('users')
            .select()
            .eq('email', user.email as Object)  // Vérifie par l'email
            .maybeSingle();

        if (existingUser == null) {
          // Obtenir la position de l'utilisateur
          Position position = await _getUserLocation();

          // Insérer l'utilisateur dans la table `users`
          await supabase.from('users').insert({
            'id': supabase.auth.currentUser?.id,  // Utilise l'ID de l'utilisateur connecté
            'created_at': DateTime.now().toIso8601String(),
            'name': user.userMetadata?['name'] ?? '',
            'email': user.email,
            'avatar_url': user.userMetadata?['picture'] ?? '',
            'latitude': position.latitude,
            'longitude': position.longitude,
          });

          print('Utilisateur ajouté avec succès');
        } else {
          print("Utilisateur avec cet email déjà existant");
        }
      } else {
        print("L'email est nul, impossible de procéder.");
      }
    } catch (e) {
      // Gestion d'erreur pour les violations de contrainte d'unicité
      if (e.toString().contains('duplicate key value violates unique constraint')) {
        print("Erreur : L'email est déjà utilisé.");
      } else {
        print("Erreur inattendue : $e");
      }
    }
  }

  // Fonction pour obtenir la localisation de l'utilisateur
  static Future<Position> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw Exception("Permission de localisation refusée");
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
