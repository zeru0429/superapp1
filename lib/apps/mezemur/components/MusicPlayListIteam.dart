import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.4;
    return Container(
      color: Colors.deepPurple, // Background color
      padding: const EdgeInsets.all(16.0), // Add padding
      child: const Text(
        "ለመምረጥ",
        style: TextStyle(
          fontFamily:
              'jiret', // Replace 'YourFont' with the desired font family
          fontSize: 28.0, // Font size
          color: Colors.white, // Text color
          fontWeight: FontWeight.bold, // FontWeight (if desired)
          fontStyle: FontStyle.italic, // FontStyle (if desired)
        ),
      ),
    );
  }
}
