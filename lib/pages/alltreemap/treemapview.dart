import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/loading_widget.dart';
import 'widgets/tree_marker.dart';

class TreeMapView extends StatelessWidget {
  final String selectedStage;

  const TreeMapView({super.key, required this.selectedStage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mango_tree')
            .where('isArchived', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _loadingWidget();
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return selectedStage == 'All Stages' || data['stage'] == selectedStage;
          }).toList();

          final List<LatLng> locations = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return LatLng(
              double.parse(data['latitude'].toString()),
              double.parse(data['longitude'].toString()),
            );
          }).toList();

          if (locations.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No data available for $selectedStage.'),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter:
                  locations.isNotEmpty ? locations[0] : const LatLng(0, 0),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                tileProvider: CancellableNetworkTileProvider(),
                userAgentPackageName: 'Manggatech',
              ),
              MarkerLayer(
                markers: TreeMarkers.buildMarkers(context, docs),
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse(
                        'https://www.openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const LoadingWidget(),
      ),
    );
  }
}
