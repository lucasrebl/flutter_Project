import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late MapWidget mapWidget;

  @override
  Widget build(BuildContext context) {
    CameraOptions camera = CameraOptions(
      center: Point(coordinates: Position(-98.0, 39.5)),
      zoom: 3.0,
      bearing: 0,
      pitch: 0,
    );

    mapWidget = MapWidget(
      key: const ValueKey("mapWidget"),
      cameraOptions: camera,
    );

    return Scaffold(
      body: mapWidget,
    );
  }
}
