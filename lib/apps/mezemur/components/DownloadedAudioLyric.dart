import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/screen/LyricPage.dart';

class YourDestinationComponent extends StatelessWidget {
  final String title;
  final bool isFav;
  final String lyric;

  const YourDestinationComponent({
    Key? key,
    required this.title,
    required this.isFav,
    required this.lyric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Center(
        child: LyricPage(
          id: title,
          isFav: isFav,
          lyric: lyric,
        ), // Access the passed title here
      ),
    );
  }
}
