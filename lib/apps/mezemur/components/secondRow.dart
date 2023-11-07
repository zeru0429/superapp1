import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondRow extends StatelessWidget {
  const SecondRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.4;
    double boxWidth2 = MediaQuery.of(context).size.width * 0.6;
    double fontSize =
        boxWidth / 6; // Font size as 5% of the first container's width

    return Expanded(
      child: Row(
        children: [
          // First half with white background and box shadow
          Container(
            width: boxWidth,
            child: Material(
              // Wrap with Material for InkWell or ripple effect
              elevation: 5, // Adjust the elevation as needed
              shadowColor: Colors.grey, // Shadow color
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                alignment: Alignment.center,
                child: Text(
                  "Hውግ",
                  style: GoogleFonts.openSans(
                    fontSize:
                        fontSize, // Font size as 5% of the first container's width
                    color: Color.fromRGBO(26, 144, 157, 1.0), // Text color
                    fontWeight: FontWeight.bold, // FontWeight (if desired)
                    fontStyle: FontStyle.italic, // FontStyle (if desired)
                  ),
                ),
              ),
            ),
          ),

          // Second half with purple background
          Material(
            elevation: 5, // Adjust the elevation as needed
            shadowColor: Colors.grey,
            child: Container(
              color: Color.fromRGBO(26, 144, 157, 1.0),
              width: boxWidth2,
              height: boxWidth / 5,
            ),
          ),
        ],
      ),
    );
  }
}
