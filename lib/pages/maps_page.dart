import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapWidget? mapWidget;
  late MapboxMap mapboxMap;

  // Fonction d'initialisation de la carte
  @override
  void initState() {
    super.initState();
    _initMap();
  }

  // Fonction pour initialiser la carte et obtenir la position de l'utilisateur
  Future<void> _initMap() async {
    geo.Position position = await _getUserLocation(); // Obtention de la position de l'utilisateur

    setState(() {
      mapWidget = MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(position.longitude, position.latitude),
          ),
          zoom: 15.0,
        ),
        onMapCreated: (MapboxMap map) {
          mapboxMap = map; // Attribution de la carte créée à la variable mapboxMap
          _enableLocation(); // Activation de la localisation
        },
      );
    });
  }

  // Fonction pour obtenir la position de l'utilisateur avec la gestion des permissions
  Future<geo.Position> _getUserLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission(); // Vérification de la permission de localisation

    // Gestion des permissions de localisation
    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
        throw Exception("Permission de localisation refusée");
      }
    }

    return await geo.Geolocator.getCurrentPosition(); // Renvoie de la position actuelle de l'utilisateur
  }

  // Fonction pour activer la fonctionnalité de localisation sur la carte
  void _enableLocation() {
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true, // Activation de la composante de localisation
      pulsingEnabled: true, // Activation de l'effet de pulsation
      pulsingColor: Colors.blue.value,
    ));
  }

  // Fonction pour recentrer la carte sur la position de l'utilisateur
  void _recenterMap() async {
    geo.Position position = await _getUserLocation(); // Obtention de la position actuelle
    mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: 15.0, // Niveau de zoom
      ),
      MapAnimationOptions(duration: 2000), // La durée doit être en millisecondes (2000 ms = 2 secondes)
    );
  }

  // Fonction pour afficher le widget de la carte ou un indicateur de chargement
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapWidget == null
          ? const Center(child: CircularProgressIndicator())
          : mapWidget!,
      floatingActionButton: FloatingActionButton(
        onPressed: _recenterMap, // Recentrage de la carte au clic
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
