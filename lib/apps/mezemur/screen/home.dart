// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/components/Language.dart';
import 'package:superapp/apps/mezemur/components/LanguageWidget.dart';
import 'package:superapp/apps/mezemur/components/CircularLanguageContainer.dart';
import 'package:superapp/apps/mezemur/components/secondRow.dart';
import 'package:superapp/apps/mezemur/components/PlaylistItemTitile.dart';
import 'package:superapp/apps/mezemur/database/db_connection.dart';
//NewPage
import 'package:superapp/apps/mezemur/screen/SingleSearchCatagory.dart';
import 'package:superapp/apps/mezemur/screen/SingleSearchCatagory2.dart';

class MusicListItem {
  final String title;
  final String imageUrl;

  MusicListItem({required this.title, required this.imageUrl});
}

class LozaHome extends StatefulWidget {
  const LozaHome({Key? key}) : super(key: key);

  @override
  State<LozaHome> createState() => _LozaHomeState();
}

class _LozaHomeState extends State<LozaHome> {
  var i = 2;
  final List<String> imageAssets = [
    'assets/images/1.JPG',
    'assets/images/2.JPG',
    'assets/images/3.JPG',
    'assets/images/4.JPG',
    'assets/images/5.JPG',
    'assets/images/6.JPG',
    'assets/images/7.JPG',
    'assets/images/8.JPG',
    'assets/images/9.JPG',
    'assets/images/10.JPG',
    'assets/images/11.JPG',
    'assets/images/12.JPG',
    'assets/images/13.JPG',
    'assets/images/14.JPG',
    'assets/images/15.JPG',
    'assets/images/16.JPG',
    'assets/images/17.JPG',
    'assets/images/18.JPG',
    'assets/images/19.JPG',
    'assets/images/20.JPG',
    // Add more image asset paths as needed
  ];

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> data2 = [];
  List<Map<String, dynamic>> data3 = [];
  Future<void> _fetchDataFromDatabase() async {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();

    try {
      final fetchedData = await dbHelper.getCategory1List();
      final fetchedData2 = await dbHelper.getCategory2List();
      final fetchedData3 = await dbHelper.getCategory3List();

      setState(() {
        data = fetchedData;
        data2 = fetchedData2;
        data3 = fetchedData3;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataFromDatabase();
  }

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 20;
    final double widthVal = boxWidth;
    int randomIndex = random.nextInt(imageAssets.length);
    double avaterSize = MediaQuery.of(context).size.width * 0.07;
    double bannerSize = MediaQuery.of(context).size.height * 0.33;
    double expandedSize = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: bannerSize,
            collapsedHeight: bannerSize,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                imageAssets[
                    randomIndex], // Use the randomly selected image asset path
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //first row
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Row(
                          children: [
                            LanguageWidget(),
                            Language(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //second row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: data.map((item) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to a new page and pass widget.text as a parameter
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SingleLanguageListPage(
                                    text: item['category1']),
                              ),
                            );
                          },
                          child: CircularLanguageContainer(
                            text: item['category1'],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  //3rd row
                  const Row(
                    children: [
                      Expanded(
                        child: SecondRow(),
                      ),
                    ],
                  ),
                  // fourth row
                  Column(
                    children: data2.map((item) {
                      if (i == 20) {
                        i = 2;
                      } else {
                        i++;
                      }
                      // print('assets/images/$i.jpg');
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to a new page and pass the name as a parameter
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage2(name: item['category2']),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 6.0, 2.0, 2.0),
                            child: Center(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Colors.deepPurple.withOpacity(0.2),
                                    radius: avaterSize,
                                    backgroundImage:
                                        AssetImage('assets/images/$i.JPG'),
                                  ),
                                  const SizedBox(width: 6),
                                  PlayListIteamTitle(title: item['category2']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
