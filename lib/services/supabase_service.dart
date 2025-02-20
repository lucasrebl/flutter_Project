import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<dynamic>> fetchUserData() async {
    final response = await client.from('users').select();

    if (response.isEmpty) {
      print('Aucun utilisateur trouvé.');
      return [];
    } else {
      print('Données récupérées : $response');
      return response;
    }
  }
}
