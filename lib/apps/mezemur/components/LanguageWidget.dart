import 'package:flutter/material.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.20;
    double fontSize =
        MediaQuery.of(context).size.width * 0.05; // 5% of screen width

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 2), // changes the position of the shadow
          ),
        ],
      ),
      child: Container(
        width: boxWidth,
        color: Colors.white, // Background color set to white
        padding: const EdgeInsets.all(12.0), // Add padding
        child: Text(
          "ቋንቋ",
          style: TextStyle(
            fontFamily:
                'jiret', // Replace 'YourFont' with the desired font family
            fontSize: fontSize, // Font size as 5% of screen width
            color: const Color.fromRGBO(
                26, 144, 157, 1.0), // Text color set to blue
            fontWeight: FontWeight.bold, // FontWeight (if desired)
            fontStyle: FontStyle.italic, // FontStyle (if desired)
          ),
        ),
      ),
    );
  }
}
