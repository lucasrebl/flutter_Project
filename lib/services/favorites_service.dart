import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesService {
  static final supabase = Supabase.instance.client;

  // Récupérer la liste des favoris de l'utilisateur connecté
  static Future<List<String>> getFavorites() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await supabase
        .from('favorites')
        .select('favorite_id')
        .eq('user_id', userId);

    return response.map<String>((fav) => fav['favorite_id'].toString()).toList();
  }

  // Ajouter un utilisateur aux favoris
  static Future<void> addFavorite(String favoriteId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('favorites').insert({
      'user_id': userId,
      'favorite_id': favoriteId,
    });
  }

  // Supprimer un utilisateur des favoris
  static Future<void> removeFavorite(String favoriteId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase
        .from('favorites')
        .delete()
        .match({'user_id': userId, 'favorite_id': favoriteId});
  }
}
