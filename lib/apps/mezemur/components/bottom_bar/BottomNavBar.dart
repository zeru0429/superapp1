import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Color.fromRGBO(0, 39, 44, 1.0)),
          Icon(Icons.favorite, size: 30, color: Color.fromRGBO(0, 39, 44, 1.0)),
          Icon(Icons.search, size: 30, color: Color.fromRGBO(0, 39, 44, 1.0)),
          Icon(Icons.download, size: 30, color: Color.fromRGBO(0, 39, 44, 1.0)),
          Icon(Icons.info, size: 30, color: Color.fromRGBO(0, 39, 44, 1.0)),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(0, 130, 146, 1.0),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: onTap,
      ),
    );
  }
}
