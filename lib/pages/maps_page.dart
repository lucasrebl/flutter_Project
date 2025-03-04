import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:typed_data'; // Pour manipuler les données d'image
import '../services/location_service.dart'; // Import du service de localisation
import '../services/all_user_services.dart';  // Import du service des utilisateurs

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapWidget? mapWidget;
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  late geo.Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  // Initialisation de la carte
  Future<void> _initMap() async {
    _currentPosition = await LocationService.getUserLocation(); // Utilisation de LocationService

    setState(() {
      mapWidget = MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: Point(
            coordinates: Position(_currentPosition.longitude, _currentPosition.latitude),
          ),
          zoom: 15.0,
        ),
        onMapCreated: (MapboxMap map) async {
          mapboxMap = map;
          _enableLocation(); // Activation de la localisation
          await _addAnnotationsForUsers(); // Ajout des annotations pour les utilisateurs
        },
      );
    });

    // Écoute des changements de position de l'utilisateur
    geo.Geolocator.getPositionStream(
      locationSettings: geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geo.Position position) {
      setState(() {
        _currentPosition = position;
      });
      _updateCameraPosition(position); // Mise à jour de la caméra avec la nouvelle position
    });
  }

  // Fonction pour récupérer tous les utilisateurs avec leurs coordonnées
  Future<void> _addAnnotationsForUsers() async {
    try {
      final users = await AllUserServices.getAllUsersExceptCurrent();

      if (users.isNotEmpty) {
        // Charger l'image de l'annotation
        final ByteData bytes = await rootBundle.load('assets/marker.png');
        final Uint8List imageData = bytes.buffer.asUint8List();

        // Créer un PointAnnotationManager pour gérer les annotations
        pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

        // Ajouter une annotation pour chaque utilisateur
        for (var user in users) {
          final latitude = user['latitude'];
          final longitude = user['longitude'];

          if (latitude != null && longitude != null) {
            PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
              geometry: Point(coordinates: Position(longitude, latitude)),
              image: imageData,
              iconSize: 0.1,
              iconAnchor: IconAnchor.BOTTOM,
            );

            // Ajouter l'annotation à la carte
            pointAnnotationManager?.create(pointAnnotationOptions);
          }
        }
      } else {
        print("Aucun utilisateur trouvé");
      }
    } catch (e) {
      print("Erreur lors de la récupération des utilisateurs : $e");
    }
  }

  // Fonction pour activer la fonctionnalité de localisation
  void _enableLocation() {
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: Colors.blue.value,
    ));
  }

  // Fonction pour mettre à jour la position de la caméra en fonction de la position de l'utilisateur
  void _updateCameraPosition(geo.Position position) {
    mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  // Fonction pour recentrer la carte
  void _recenterMap() async {
    geo.Position position = await LocationService.getUserLocation(); // Utilisation de LocationService
    mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapWidget == null
          ? const Center(child: CircularProgressIndicator())
          : mapWidget!,
      floatingActionButton: FloatingActionButton(
        onPressed: _recenterMap,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
