import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String description;
  final double padding;

  const CustomHeader(
      {Key? key,
      required this.title,
      required this.description,
      this.padding = 30.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          padding: EdgeInsets.all(padding),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
