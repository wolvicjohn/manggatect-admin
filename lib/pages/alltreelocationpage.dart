import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class AllTreeLocationPage extends StatefulWidget {
  const AllTreeLocationPage({Key? key}) : super(key: key);

  @override
  AllTreeLocationPageState createState() => AllTreeLocationPageState();
}

class AllTreeLocationPageState extends State<AllTreeLocationPage> {
  String selectedStage = 'All Stages'; // Default to show all stages
  List<String> stages = [
    'All Stages',
    'stage-1',
    'stage-2',
    'stage-3',
    'stage-4'
  ];

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 20, 116, 82),
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
                  'All Mango Tree Locations',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('mango_tree')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // Get all tree locations based on selectedStage
                      final List<LatLng> locations =
                          snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return selectedStage == 'All Stages' ||
                            data['stage'] ==
                                selectedStage; // Show all or filter
                      }).map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return LatLng(
                          double.parse(data['latitude'].toString()),
                          double.parse(data['longitude'].toString()),
                        );
                      }).toList();

                      // Show a message if there are no locations for the selected stage
                      if (locations.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('No data available for $selectedStage.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                      }

                      return FlutterMap(
                        options: MapOptions(
                          initialCenter: locations.isNotEmpty
                              ? locations[0]
                              : const LatLng(0, 0),
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            tileProvider: CancellableNetworkTileProvider(),
                            userAgentPackageName: 'Manggatech',
                          ),
                          MarkerLayer(
                            markers: locations.map((location) {
                              // Find the corresponding document to get its 'stage'
                              final doc = snapshot.data!.docs.firstWhere((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return double.parse(
                                            data['latitude'].toString()) ==
                                        location.latitude &&
                                    double.parse(
                                            data['longitude'].toString()) ==
                                        location.longitude;
                              });
                              final data = doc.data() as Map<String, dynamic>;
                              final stage = data['stage'];

                              String iconPath;
                              switch (stage) {
                                case 'stage-1':
                                  iconPath = 'assets/images/tree_icon.png';
                                  break;
                                case 'stage-2':
                                  iconPath = 'assets/images/stage1_icon.png';
                                  break;
                                case 'stage-3':
                                  iconPath = 'assets/images/stage2_icon.png';
                                  break;
                                case 'stage-4':
                                  iconPath = 'assets/images/stage3_icon.png';
                                  break;
                                default:
                                  iconPath = 'assets/images/logo.png';
                              }

                              return Marker(
                                point: location,
                                width: 50.0,
                                height: 50.0,
                                child: Image.asset(
                                  iconPath,
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
                                onTap: () => launchUrl(Uri.parse(
                                    'https://www.openstreetmap.org/copyright')),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Dropdown button for selecting stages, positioned at the top-right corner
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 20, 116, 82)),
                          ),
                          child: DropdownButton<String>(
                            value: selectedStage,
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.black87),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            dropdownColor: Colors.white,
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
                        const SizedBox(height: 10),
                        const Text(
                          'LEGENDS',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/tree_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const Text('Stage 1'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/stage1_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const Text('Stage 2'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/stage2_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const Text('Stage 3'),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/stage3_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const Text('Stage 4'),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
