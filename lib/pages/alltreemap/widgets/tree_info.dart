import 'package:adminmangga/services/imagewidget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../services/loading_widget.dart';

class ImageInfoBottomSheet {
  static void show({
    required BuildContext context,
    required String? imageUrl,
    required String? stageImageUrl,
    required String stage,
    required String uploader,
    required String timestamp,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWidget(imageUrl: imageUrl, width: 100, height: 100),
                  StageImageWidget(
                      stageImageUrl: stageImageUrl, width: 100, height: 100),
                ],
              ),
              const SizedBox(height: 10),
              Text(stage,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Divider(),
              const Text('Uploaded by',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(uploader, style: const TextStyle(fontSize: 16)),
              const Divider(),
              const Text('Uploaded on',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(timestamp, style: const TextStyle(fontSize: 16)),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
