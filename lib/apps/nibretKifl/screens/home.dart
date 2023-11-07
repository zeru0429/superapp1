import 'package:flutter/material.dart';
// import 'package:mezemur_app/appllications/mezemur/screens/MyListView.dart';
// import 'package:superapp/apps/nibretkifl/components/bottom_bar/BottomNavBar.dart';
import 'package:superapp/component/MyListView.dart';

// ignore: camel_case_types
class homeNibretkfil extends StatefulWidget {
  const homeNibretkfil({super.key});

  @override
  State<homeNibretkfil> createState() => _homeNibretkfilState();
}

class _homeNibretkfilState extends State<homeNibretkfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(149, 117, 205, 1),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onItemTapped,
      // ),
      body: Center(
        child: MyListView(),
        //child: Text("data"),
      ),
    );
  }
}
