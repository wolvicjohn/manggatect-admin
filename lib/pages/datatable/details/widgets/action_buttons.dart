import 'package:flutter/material.dart';
import 'package:adminmangga/qrcode/qrcodegeneratorpage.dart';
import 'package:adminmangga/treelocationpage/TreeLocationPage.dart';

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> treeData;

  const ActionButtons({super.key, required this.treeData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeGeneratorPage(
                    docID: treeData['docID'],
                    timestamp: treeData['timestamp'].toDate(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.qr_code, color: Colors.white),
            label: const Text(
              "Generate QR Code",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TreeLocationPage(
                    latitude: double.tryParse(
                            treeData['latitude'] ?? '0.0') ??
                        0.0,
                    longitude: double.tryParse(
                            treeData['longitude'] ?? '0.0') ??
                        0.0,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.location_pin, color: Colors.white),
            label: const Text(
              "Get Location",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
