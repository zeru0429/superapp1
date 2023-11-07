import 'package:flutter/material.dart';

class PlayListIteamTitle extends StatelessWidget {
  final String title;

  const PlayListIteamTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.8;
    double fontSize =
        MediaQuery.of(context).size.width * 0.04; // 5% of screen width

    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(26, 144, 157, 1.0)
            .withOpacity(0.7), // Background color set to deep purple
        borderRadius: BorderRadius.circular(100.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2), // Shadow offset
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0), // Add padding
      child: Text(
        title, // Use the title passed from the parent
        style: TextStyle(
          fontFamily:
              'jiret', // Replace 'YourFont' with the desired font family
          fontSize: fontSize, // Font size as 5% of screen width
          color: Colors.black, // Text color set to white
          fontWeight: FontWeight.w200, // FontWeight (if desired)
          fontStyle: FontStyle.italic, // FontStyle (if desired)
        ),
      ),
    );
  }
}
