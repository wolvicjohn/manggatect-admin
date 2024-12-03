import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class TreeLocationPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const TreeLocationPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _TreeLocationPageState createState() => _TreeLocationPageState();
}

class _TreeLocationPageState extends State<TreeLocationPage> {
  Future<void> _launchCopyrightUrl() async {
    final url = Uri.parse('https://www.openstreetmap.org/copyright');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: const Text('Tree Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.latitude, widget.longitude),
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Removed subdomains
            userAgentPackageName: 'Manggatect',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(widget.latitude, widget.longitude),
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
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: _launchCopyrightUrl,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
