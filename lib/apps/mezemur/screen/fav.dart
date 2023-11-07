import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/components/unorder/FavPageList.dart.dart';

class favMezemur extends StatefulWidget {
  const favMezemur({super.key});

  @override
  State<favMezemur> createState() => _favMezemurState();
}

class _favMezemurState extends State<favMezemur> {
  @override
  Widget build(BuildContext context) {
    return const Material(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(26, 144, 157, 1.0),
      // body: MyListView(),
      body: Center(
        child: FavPageList(title: 'mezemur', isFirstLaunch: true),
      ),
    ));
  }
}
