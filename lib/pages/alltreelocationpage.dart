import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/admin_panel.dart';

class AllTreeLocationPage extends StatefulWidget {
  const AllTreeLocationPage({Key? key}) : super(key: key);

  @override
  _AllTreeLocationPageState createState() => _AllTreeLocationPageState();
}

class _AllTreeLocationPageState extends State<AllTreeLocationPage> {
  String selectedStage = 'stage-1';
  List<String> stages = ['stage-1', 'stage-2', 'stage-3', 'stage-4'];

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header for the map
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.yellowAccent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 6),
                  blurRadius: 12.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            child: const Text(
              'MAP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // StreamBuilder for fetching tree locations
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 6),
                    blurRadius: 12.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              margin: const EdgeInsets.all(16),
              child: Expanded(
                child: Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('notes')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final List<LatLng> locations =
                            snapshot.data!.docs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['stage'] == selectedStage &&
                              data['latitude'] != null &&
                              data['longitude'] != null;
                        }).map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return LatLng(
                            double.tryParse(data['latitude'].toString()) ?? 0.0,
                            double.tryParse(data['longitude'].toString()) ??
                                0.0,
                          );
                        }).toList();

                        if (locations.isEmpty) {
                          Future.microtask(() {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'No data available for $selectedStage.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        }

                        return FlutterMap(
                          options: MapOptions(
                            initialCenter: locations.isNotEmpty
                                ? locations[0]
                                : LatLng(14.5995, 120.9842), // Default: Manila
                            initialZoom: 20.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
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
                                  onTap: () async {
                                    final url = Uri.parse(
                                        'https://www.openstreetmap.org/copyright');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    // Dropdown button for selecting stages, positioned at the top-right corner
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedStage,
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.black),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          dropdownColor: Colors.yellowAccent,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStage = newValue!;
                            });
                          },
                          items: stages
                              .map<DropdownMenuItem<String>>((String stage) {
                            return DropdownMenuItem<String>(
                              value: stage,
                              child: Text(stage),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
