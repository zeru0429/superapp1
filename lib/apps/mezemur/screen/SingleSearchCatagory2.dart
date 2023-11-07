import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/components/unorder/Catagory2List.dart';

class NewPage2 extends StatelessWidget {
  final String name; // Change 'text' to 'name'

  const NewPage2({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Catagory2List(title: '$name', isFirstLaunch: true),
      ),
    );
  }
}
