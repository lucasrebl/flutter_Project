import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/location_service.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        final response = await Supabase.instance.client
            .from('users')
            .select()
            .neq('id', userId)
            .order('created_at', ascending: false);

        if (response != null) {
          final users = List<Map<String, dynamic>>.from(response);

          // Récupérer la position actuelle de l'utilisateur
          geo.Position? currentPosition = await LocationService.getUserLocation();

          if (currentPosition != null) {
            _users = users.map((user) {
              double userLat = user["latitude"] ?? 0.0;
              double userLng = user["longitude"] ?? 0.0;

              double distanceInMeters = geo.Geolocator.distanceBetween(
                currentPosition.latitude,
                currentPosition.longitude,
                userLat,
                userLng,
              );

              double distanceInKm = distanceInMeters / 1000;

              return {
                ...user,
                "distanceKm": distanceInKm.toStringAsFixed(1),
              };
            }).toList();
          } else {
            _users = users;
          }
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}