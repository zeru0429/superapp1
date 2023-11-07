// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CircularLanguageContainer extends StatefulWidget {
  final String text;

  const CircularLanguageContainer({Key? key, required this.text})
      : super(key: key);

  @override
  State<CircularLanguageContainer> createState() =>
      _CircularLanguageContainerState();
}

class _CircularLanguageContainerState extends State<CircularLanguageContainer> {
  @override
  Widget build(BuildContext context) {
    double circularSize =
        MediaQuery.of(context).size.width * 0.18; // Adjust the factor as needed
    double fontSize =
        MediaQuery.of(context).size.width * 0.04; // 5% of screen width
    double avaterSize = MediaQuery.of(context).size.width * 0.07;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: circularSize,
        height: circularSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromRGBO(26, 144, 157, 1.0),
            width: 5.0,
          ),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: const Color.fromRGBO(26, 144, 157, 1.0),
              fontSize: fontSize,
              fontFamily: 'jiret', // Replace with your desired font
            ),
          ),
        ),
      ),
    );
  }
}
