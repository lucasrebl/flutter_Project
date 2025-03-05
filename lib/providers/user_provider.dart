import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../services/location_service.dart';
import '../services/all_user_services.dart';
import '../services/favorites_service.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];
  List<String> _favoriteIds = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get users => _users;
  bool get isLoading => _isLoading;
  List<String> get favoriteIds => _favoriteIds;

  // Vérifier si un utilisateur est favori
  bool isFavorite(String userId) {
    return _favoriteIds.contains(userId);
  }

  // Charger les utilisateurs et calculer la distance
  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> users = await AllUserServices.getAllUsersExceptCurrent();
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

      // Charger les favoris
      await loadFavorites();
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Charger les favoris
  Future<void> loadFavorites() async {
    _favoriteIds = await FavoritesService.getFavorites();
    notifyListeners();
  }

  // Ajouter ou supprimer un favori
  Future<void> toggleFavorite(String userId) async {
    if (isFavorite(userId)) {
      await FavoritesService.removeFavorite(userId);
      _favoriteIds.remove(userId);
    } else {
      await FavoritesService.addFavorite(userId);
      _favoriteIds.add(userId);
    }
    notifyListeners();
  }
}
