import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

          final List<LatLng> locations = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return selectedStage == 'All Stages' ||
                data['stage'] == selectedStage;
          }).map((doc) {
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
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                tileProvider: CancellableNetworkTileProvider(),
                userAgentPackageName: 'Manggatech',
              ),
              MarkerLayer(
                markers: locations.map((location) {
                  final doc = snapshot.data!.docs.firstWhere((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return double.parse(data['latitude'].toString()) ==
                            location.latitude &&
                        double.parse(data['longitude'].toString()) ==
                            location.longitude;
                  });
                  final data = doc.data() as Map<String, dynamic>;
                  final stage = data['stage'];
                  final uploader = data['uploader'];
                  final timestamp = DateFormat('EEEE, MMMM dd, yyyy h:mm a')
                      .format(data['timestamp'].toDate());
                  final String? imageUrl = data['imageUrl'];
                  final String? stageImageUrl = data['stageImageUrl'];

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
                      iconPath = 'assets/images/tree.png';
                  }

                  return Marker(
                    point: location,
                    width: 50.0,
                    height: 50.0,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: data['imageUrl'] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                    imageUrl: imageUrl!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child:
                                                              const LoadingIndicator(
                                                            indicatorType: Indicator
                                                                .lineScalePulseOutRapid,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  20,
                                                                  116,
                                                                  82),
                                                              Colors.yellow,
                                                              Colors.red,
                                                              Colors.blue,
                                                              Colors.orange,
                                                            ],
                                                            strokeWidth: 3,
                                                          ),
                                                        ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          color: Colors
                                                              .grey.shade200,
                                                          child: const Icon(Icons
                                                              .error_outline),
                                                        )),
                                              )
                                            : Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Icon(Icons
                                                    .image_not_supported_outlined),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: data['stageImageUrl'] != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                    imageUrl: stageImageUrl!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        Container(
                                                          width: 100,
                                                          height: 100,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          child:
                                                              const LoadingIndicator(
                                                            indicatorType: Indicator
                                                                .lineScalePulseOutRapid,
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  20,
                                                                  116,
                                                                  82),
                                                              Colors.yellow,
                                                              Colors.red,
                                                              Colors.blue,
                                                              Colors.orange,
                                                            ],
                                                            strokeWidth: 3,
                                                          ),
                                                        ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          color: Colors
                                                              .grey.shade200,
                                                          child: const Icon(Icons
                                                              .error_outline),
                                                        )),
                                              )
                                            : Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: const Icon(Icons
                                                    .image_not_supported_outlined),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text('$stage',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  const Text('Uploaded by',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text(uploader,
                                      style: const TextStyle(fontSize: 16)),
                                  const Divider(),
                                  const Text('Uploaded on',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey)),
                                  Text(timestamp,
                                      style: const TextStyle(fontSize: 16)),
                                  const Divider()
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        iconPath,
                        width: 40.0,
                        height: 40.0,
                      ),
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
        child: const LoadingIndicator(
          indicatorType: Indicator.lineScalePulseOutRapid,
          colors: [
            Color.fromARGB(255, 20, 116, 82),
            Colors.yellow,
            Colors.red,
            Colors.blue,
            Colors.orange,
          ],
          strokeWidth: 3,
        ),
      ),
    );
  }
}
