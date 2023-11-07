import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:superapp/apps/mezemur/components/audioplayers/audio.dart';
import 'package:superapp/apps/mezemur/database/db_connection.dart';

class LyricPage extends StatefulWidget {
  final String id;
  final String lyric;
  final bool isFav;

  const LyricPage({
    required this.id,
    required this.lyric,
    required this.isFav,
  });

  @override
  _LyricPageState createState() => _LyricPageState(isFav);
}

class _LyricPageState extends State<LyricPage> {
  bool isFavorite;
  bool _isDownloading = false; // Add this variable

  _LyricPageState(bool isFav) : isFavorite = isFav;

  void _toggleFavorite() async {
    final dbHelper = DatabaseConnection();
    await dbHelper.setDatabase();
    // print(widget.id);

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      final id = int.parse(widget.id.split(', ').first);

      // Perform the database operation asynchronously
      Future(() async {
        if (isFavorite) {
          // If the item is marked as a favorite, add it to the database
          await dbHelper.addFavorite(id);
        } else {
          // If the item is not a favorite, remove it from the database
          await dbHelper.removeFavorite(id);
        }
      });
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  Future<void> _downloadAudio() async {
    if (_isDownloading) {
      return; // Prevent multiple downloads at the same time
    }

    setState(() {
      _isDownloading =
          true; // Set the flag to indicate that download is in progress
    });

    try {
      final fileName = widget.id;
      final appDirectory = await getApplicationDocumentsDirectory();
      final filePath = '${appDirectory.path}/$fileName.mp3';
      final file = File(filePath);

      if (!file.existsSync()) {
        final dio = Dio();
        await dio.download(
          "https://gibigubaemezemur.huludelala.com/allmezemurs/${widget.id}.mp3",
          filePath,
        );
        // Audio downloaded successfully
      }

      setState(() {
        _isDownloading = false; // Download completed, reset the flag
      });
    } catch (e) {
      setState(() {
        _isDownloading = false; // Handle download error and reset the flag
      });
      // Handle download error here
    }
  }

  @override
  Widget build(BuildContext context) {
    double textFontSize = MediaQuery.of(context).size.width * 0.05;
    double textFontSize2 = MediaQuery.of(context).size.width * 0.040;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/images/4.JPG'), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.id,
                style: TextStyle(
                  fontSize: textFontSize2,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'jiret',
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: _toggleFavorite,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(58, 0, 0, 0)
                              .withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.lyric,
                        style: TextStyle(
                          fontSize: textFontSize,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'jiret',
                          color: Color.fromARGB(255, 10, 10, 10),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              AudioPlayerWidget(
                audioUrl:
                    "https://gibigubaemezemur.huludelala.com/allmezemurs/${widget.id}.mp3",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
