import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo; // Alias pour éviter le conflit

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  MapWidget? mapWidget;  // Déclarez mapWidget comme nullable
  late MapboxMap mapboxMap;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    geo.Position position = await _getUserLocation();

    setState(() {
      // Initialisation de la carte seulement une fois les coordonnées récupérées
      mapWidget = MapWidget(
        key: const ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
          center: Point( // ✅ Utilisation du bon Point de mapbox_maps_flutter
            coordinates: Position(position.longitude, position.latitude),
          ),
          zoom: 15.0,
        ),
        onMapCreated: (MapboxMap map) {
          mapboxMap = map;
          _enableLocation();
        },
      );
    });
  }

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

  void _enableLocation() {
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: Colors.blue.value,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapWidget == null
          ? const Center(child: CircularProgressIndicator()) // Affichage du chargement tant que la carte n'est pas prête
          : mapWidget!,  // Utilisation de mapWidget une fois initialisé
    );
  }
}
