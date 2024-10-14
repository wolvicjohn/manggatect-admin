import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_panel.dart';

class AllTreeLocationPage extends StatelessWidget {
  const AllTreeLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<LatLng> locations = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return LatLng(
              double.parse(data['latitude'].toString()),
              double.parse(data['longitude'].toString()),
            );
          }).toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: locations.isNotEmpty
                  ? locations[0]
                  : LatLng(0, 0),
              initialZoom: 20.0, 
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'Manggatect', 
              ),
              MarkerLayer(
                markers: locations.map((location) {
                  return Marker(
                    point: location,
                    width: 50.0,
                    height: 50.0,
                    child: Image.asset(
                      'assets/images/tree_icon.png', 
                      width: 40.0,
                      height: 40.0,
                    ),
                  );
                }).toList(),
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                        Uri.parse('https://www.openstreetmap.org/copyright')),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
