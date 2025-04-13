import 'package:flutter/material.dart';

TableRow buildTableHeader() {
  return TableRow(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 20, 116, 82),
      borderRadius: BorderRadius.circular(4.0),
    ),
    children: const [
      _HeaderCell("No."),
      _HeaderCell("Image"),
      _HeaderCell("Stage"),
      _HeaderCell("Uploader"),
      _HeaderCell("Date Uploaded"),
      _HeaderCell("Actions"),
    ],
  );
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
