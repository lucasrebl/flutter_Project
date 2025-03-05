import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../services/location_service.dart';
import '../services/all_user_services.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;

  // Fonction pour charger les utilisateurs et calculer la distance
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Récupérer les utilisateurs à partir du service AllUserServices
      List<Map<String, dynamic>> users = await AllUserServices.getAllUsersExceptCurrent();

      // Récupérer la position actuelle de l'utilisateur
      geo.Position? currentPosition = await LocationService.getUserLocation();

      if (currentPosition != null) {
        // Calculer la distance pour chaque utilisateur
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
            "distanceKm": distanceInKm.toStringAsFixed(1),  // On garde la distance sous forme de chaîne
          };
        }).toList();
      } else {
        _users = users;
      }
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
