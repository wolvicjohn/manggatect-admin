import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map_utils.dart';
import 'tree_info.dart';

class TreeMarkers {
  static List<Marker> buildMarkers(BuildContext context, List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final LatLng location = LatLng(
        double.parse(data['latitude'].toString()),
        double.parse(data['longitude'].toString()),
      );
      final String stage = data['stage'];
      final String uploader = data['uploader'];
      final String timestamp = DateFormat('EEEE, MMMM dd, yyyy h:mm a')
          .format(data['timestamp'].toDate());
      final String? imageUrl = data['imageUrl'];
      final String? stageImageUrl = data['stageImageUrl'];
      final String iconPath = MapUtils.getIconPath(stage);

      return Marker(
        point: location,
        width: 50.0,
        height: 50.0,
        child: GestureDetector(
          onTap: () {
            ImageInfoBottomSheet.show(
              context: context,
              imageUrl: imageUrl,
              stageImageUrl: stageImageUrl,
              stage: stage,
              uploader: uploader,
              timestamp: timestamp,
            );
          },
          child: Image.asset(
            iconPath,
            width: 40.0,
            height: 40.0,
          ),
        ),
      );
    }).toList();
  }
}
