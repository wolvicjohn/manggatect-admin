import 'package:flutter/material.dart';

Color getUploaderColor(String uploader) {
  final int hash = uploader.hashCode;
  final int r = 50 + (hash & 0x7F);
  final int g = 50 + ((hash >> 7) & 0x7F);
  final int b = 50 + ((hash >> 14) & 0x7F);
  return Color.fromARGB(255, r, g, b);
}
