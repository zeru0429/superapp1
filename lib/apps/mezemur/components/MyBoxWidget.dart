import 'package:flutter/material.dart';

class MyBoxWidget extends StatelessWidget {
  const MyBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double boxWidth =
        MediaQuery.of(context).size.width * 0.2; // 20% of screen width

    return SizedBox(
      width: boxWidth,
      height: double.infinity, // Set height to fill the available space
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white, // White background color
              child: Center(
                child: Text(
                  'White Half',
                  style: TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.purple, // Purple background color
            ),
          ),
        ],
      ),
    );
  }
}
