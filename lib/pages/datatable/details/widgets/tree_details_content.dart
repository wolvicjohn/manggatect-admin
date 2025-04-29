import 'package:adminmangga/services/imagewidget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../qrcode/qrcodegeneratorpage.dart';
import 'tree_map_widget.dart';

class TreeDetailsContent extends StatelessWidget {
  final Map<String, dynamic> treeData;

  const TreeDetailsContent({super.key, required this.treeData});

  @override
  Widget build(BuildContext context) {
    double latitude = double.parse(treeData['latitude']);
    double longitude = double.parse(treeData['longitude']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Details Section (top)
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tree Details
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDetailItem(
                      icon: Icons.info,
                      label: "ID",
                      value: treeData['docID'] ?? 'N/A',
                    ),
                    _buildDetailItem(
                      icon: Icons.person,
                      label: "Uploaded by",
                      value: treeData['uploader'] ?? 'N/A',
                    ),
                    _buildDetailItem(
                      icon: Icons.location_on,
                      label: "Longitude",
                      value: treeData['longitude'] ?? 'N/A',
                    ),
                    _buildDetailItem(
                      icon: Icons.location_searching,
                      label: "Latitude",
                      value: treeData['latitude'] ?? 'N/A',
                    ),
                    _buildDetailItem(
                      icon: Icons.eco,
                      label: "Current Stage",
                      value: treeData['stage'] ?? 'N/A',
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),
              // QR Code
              Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: treeData['docID'] ?? 'N/A',
                      version: QrVersions.auto,
                      gapless: false,
                      errorStateBuilder: (context, error) => const Center(
                        child: Text(
                          'Error!',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => PdfDownloader.downloadQrCodeAsPdf(
                        context, treeData['docID']),
                    icon: const Icon(
                      Icons.download,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      "Download",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Flower Stage Image (below the details)
        const Divider(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  'Flower Stage',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                StageImageWidget(
                  stageImageUrl: treeData['stageImageUrl'],
                  width: 200,
                  height: 200,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                const Text(
                  'Mango Tree',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                ImageWidget(
                  imageUrl: treeData['imageUrl'],
                  width: 200,
                  height: 200,
                ),
              ],
            ),
            const SizedBox(width: 20),
            // map
            Column(
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12.0),
                TreeMapWidget(
                  latitude: latitude,
                  longitude: longitude,
                  width: 400,
                  height: 200,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
