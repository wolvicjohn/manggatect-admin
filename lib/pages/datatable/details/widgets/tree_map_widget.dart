import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TreeMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final double width;
  final double height;

  const TreeMapWidget({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: width,
        height: height,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'MANGGATECH',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(latitude, longitude),
                  width: 50.0,
                  height: 50.0,
                  child: Image.asset(
                    'assets/images/tree_icon.png',
                    width: 40.0,
                    height: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
