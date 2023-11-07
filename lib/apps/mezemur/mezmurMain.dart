import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:superapp/apps/mezemur/components/bottom_bar/BottomNavBar.dart';
import 'package:superapp/apps/mezemur/screen/about.dart';
import 'package:superapp/apps/mezemur/screen/fav.dart';
import 'package:superapp/apps/mezemur/screen/home.dart';
import 'package:superapp/apps/mezemur/screen/search.dart';
import 'package:superapp/apps/mezemur/screen/DownloadedAudioListWidget.dart';

class MezmurMain extends StatefulWidget {
  const MezmurMain({Key? key}) : super(key: key);

  @override
  State<MezmurMain> createState() => _MezmurMainState();
}

class _MezmurMainState extends State<MezmurMain> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _keyboardVisible = false;

  final List<Widget> _screens = [
    LozaHome(),
    favMezemur(),
    searchMezemur(),
    DownloadedAudioListWidget(),
    AboutMezemur(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance?.window.viewInsets.bottom ?? 0;
    setState(() {
      _keyboardVisible = bottomInset > 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mezemur App"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - kToolbarHeight,
              child: _screens[_currentIndex],
            ),
          ),
          if (!_keyboardVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onItemTapped,
              ),
            ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
