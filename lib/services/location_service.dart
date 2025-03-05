// location_service.dart
import 'package:geolocator/geolocator.dart' as geo;

class LocationService {
  // Fonction pour obtenir la position actuelle de l'utilisateur
  static Future<geo.Position> getUserLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
        throw Exception("Permission de localisation refusée");
      }
    }

    return await geo.Geolocator.getCurrentPosition();
  }
}
