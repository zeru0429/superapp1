import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  const Language({Key? key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.79;
    double fontSize =
        MediaQuery.of(context).size.width * 0.05; // 5% of screen width

    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(26, 144, 157, 1.0).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Container(
        color: const Color.fromRGBO(26, 144, 157, 1.0), // Background color
        padding: const EdgeInsets.all(12.0), // Add padding
        child: Text(
          "ለመምረጥ",
          style: TextStyle(
            fontFamily:
                'jiret', // Replace 'YourFont' with the desired font family
            fontSize: fontSize, // Font size as 5% of screen width
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold, // FontWeight (if desired)
            fontStyle: FontStyle.italic, // FontStyle (if desired)
          ),
        ),
      ),
    );
  }
}
