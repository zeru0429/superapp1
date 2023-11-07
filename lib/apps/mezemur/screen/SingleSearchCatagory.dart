import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/components/unorder/Catagory1List.dart';

class SingleLanguageListPage extends StatelessWidget {
  final String text;

  const SingleLanguageListPage({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$text'),
      ),
      body: Center(
        child: Catagory1List(title: '$text', isFirstLaunch: true),
      ),
    );
  }
}
