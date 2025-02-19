import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/services.dart'; // Pour rootBundle
import 'dart:typed_data'; // Pour manipuler les données d'image


class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapWidget? mapWidget;
  late MapboxMap mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

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
        onMapCreated: (MapboxMap map) async {
          mapboxMap = map;
          _enableLocation(); // Activation de la localisation
          await _addAnnotation(); // Ajout de l'annotation
        },
      );
    });
  }

  // Fonction pour ajouter une annotation à la carte
  Future<void> _addAnnotation() async {
    pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

    // Charger l'image depuis les assets
    final ByteData bytes = await rootBundle.load('assets/marker.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    // Créer les options pour l'annotation
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: Position(2.3522, 48.8566)), // Exemples de coordonnées (Paris)
      image: imageData,
      iconSize: 0.1,
      iconAnchor: IconAnchor.BOTTOM
    );

    // Ajouter l'annotation à la carte
    pointAnnotationManager?.create(pointAnnotationOptions);
  }

  // Fonction pour obtenir la position de l'utilisateur
  Future<geo.Position> _getUserLocation() async {
    geo.LocationPermission permission = await geo.Geolocator.checkPermission();

    if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied || permission == geo.LocationPermission.deniedForever) {
        throw Exception("Permission de localisation refusée");
      }
    }

    return await geo.Geolocator.getCurrentPosition();
  }

  // Fonction pour activer la fonctionnalité de localisation
  void _enableLocation() {
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: Colors.blue.value,
    ));
  }

  // Fonction pour recentrer la carte
  void _recenterMap() async {
    geo.Position position = await _getUserLocation();
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

