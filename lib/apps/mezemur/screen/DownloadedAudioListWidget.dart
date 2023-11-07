import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:superapp/apps/mezemur/database/db_connection.dart';
import 'package:superapp/apps/mezemur/components/DownloadedAudioLyric.dart';

class DownloadedAudioListWidget extends StatefulWidget {
  @override
  _DownloadedAudioListWidgetState createState() =>
      _DownloadedAudioListWidgetState();
}

class _DownloadedAudioListWidgetState extends State<DownloadedAudioListWidget> {
  List<String> _downloadedAudioFiles = [];

  @override
  void initState() {
    super.initState();
    _getDownloadedAudioFiles();
  }

  Future<void> _getDownloadedAudioFiles() async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final files = appDirectory.listSync();
    final audioFiles =
        files.where((file) => file.path.endsWith('.mp3')).toList();

    audioFiles.sort((a, b) {
      final titleA = a.path
          .split('/')
          .last
          .substring(0, a.path.split('/').last.lastIndexOf('.'));
      final titleB = b.path
          .split('/')
          .last
          .substring(0, b.path.split('/').last.lastIndexOf('.'));
      return titleA.compareTo(titleB);
    });

    setState(() {
      _downloadedAudioFiles = audioFiles.map((file) => file.path).toList();
    });
  }

  void _onAudioItemTap(String title, BuildContext context) async {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();

    try {
      final id = int.parse(title.split(', ').first);
      print("-----------------------------");
      print(title.split(', ').first);
      final data = await dbHelper.listSinglemezemur(id);
      final mezmur = data[0];
      print(mezmur);
      final isFav = mezmur['isFav'];
      final lyric = mezmur['lyric'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => YourDestinationComponent(
            title: title,
            isFav: isFav == 1, // Assuming isFav is 1 for true, 0 for false
            lyric: lyric,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _downloadedAudioFiles.length,
      itemBuilder: (context, index) {
        final fileName = _downloadedAudioFiles[index].split('/').last;
        final title = fileName.substring(0, fileName.lastIndexOf('.'));
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Make the title bold
              ),
            ),
            leading: const Icon(
              Icons
                  .music_note, // You can change the icon to a music note or any other appropriate icon
              size: 36,
              color: const Color.fromRGBO(
                  26, 144, 157, 1.0), // Adjust the icon size as needed
            ),
            trailing: Icon(
              Icons
                  .arrow_forward, // Use an arrow icon or any other appropriate icon
              size: 24, // Adjust the icon size as needed
            ),
            onTap: () {
              // Handle item tap here, you can navigate and pass the title
              _onAudioItemTap(title, context);
            },
          ),
        );
      },
    );
  }
}

// Define your destination component here
