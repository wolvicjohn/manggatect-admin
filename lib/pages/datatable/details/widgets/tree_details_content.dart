import 'package:adminmangga/services/imagewidget.dart';
import 'package:flutter/material.dart';

class TreeDetailsContent extends StatelessWidget {
  final Map<String, dynamic> treeData;

  const TreeDetailsContent({super.key, required this.treeData});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Details Section (Left)
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                label: "Stage",
                value: treeData['stage'] ?? 'N/A',
              ),
            ],
          ),
        ),
        const SizedBox(width: 16.0), // Space between columns

        // Flower Stage Image (Right)
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Row(
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
                ],
              ),
            ],
          ),
        ),
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
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
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
    );
  }
}
