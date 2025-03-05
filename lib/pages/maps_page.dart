import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:typed_data';
import '../providers/user_provider.dart';
import '../services/location_service.dart';

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

  Future<void> _initMap() async {
    _currentPosition = await LocationService.getUserLocation();

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
          _enableLocation();
          await _addAnnotationsForUsers();
        },
      );
    });

    geo.Geolocator.getPositionStream(
      locationSettings: geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geo.Position position) {
      setState(() {
        _currentPosition = position;
      });
      _updateCameraPosition(position);
    });
  }

  Future<void> _addAnnotationsForUsers() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final users = userProvider.users;

    if (users.isNotEmpty) {
      final ByteData bytes = await rootBundle.load('assets/marker.png');
      final Uint8List imageData = bytes.buffer.asUint8List();

      pointAnnotationManager = await mapboxMap.annotations.createPointAnnotationManager();

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

          pointAnnotationManager?.create(pointAnnotationOptions);
        }
      }
    } else {
      print("Aucun utilisateur trouvé");
    }
  }

  void _enableLocation() {
    mapboxMap.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
      pulsingColor: Colors.blue.value,
    ));
  }

  void _updateCameraPosition(geo.Position position) {
    mapboxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(position.longitude, position.latitude)),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  void _recenterMap() async {
    geo.Position position = await LocationService.getUserLocation();
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