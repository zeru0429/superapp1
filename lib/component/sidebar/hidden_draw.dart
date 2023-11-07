import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:superapp/apps/mezemur/mezmurMain.dart';
import 'package:superapp/apps/mezemur/screen/home.dart';
import 'package:superapp/apps/mezemur/components/unorder/UnorderList.dart';

const baseStylesforSidebar = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

// ignore: camel_case_types
class Hidden_draw extends StatefulWidget {
  const Hidden_draw({super.key});

  @override
  State<Hidden_draw> createState() => _Hidden_drawState();
}

// ignore: camel_case_types
class _Hidden_drawState extends State<Hidden_draw> {
  List<ScreenHiddenDrawer> _pages = [];
  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Mezemur App',
            baseStyle: baseStylesforSidebar,
            selectedStyle: const TextStyle(),
          ),
          MezmurMain()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple.shade300,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 40,
    );
  }
}
