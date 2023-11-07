import 'package:flutter/material.dart';
import 'package:superapp/apps/mezemur/database/db_connection.dart';

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    DatabaseConnection db = DatabaseConnection();
    // await db.setDatabase();
    // await db.insertData();
    List<Map<String, dynamic>> list = await db.listData();
    setState(() {
      dataList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List View'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataList[index]['title']),
            subtitle: Text(dataList[index]['category1']),
          );
        },
      ),
    );
  }
}
