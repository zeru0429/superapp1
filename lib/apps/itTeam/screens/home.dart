import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:superapp/apps/mezemur/components/audioplayers/audio.dart';
import 'package:superapp/component/MyListView.dart';

class homeItteam extends StatefulWidget {
  const homeItteam({Key? key});

  @override
  State<homeItteam> createState() => _homeItteamState();
}

class _homeItteamState extends State<homeItteam> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  String audioPath = 'audios/audio2.mp3';

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100], // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8, // Add elevation for a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons
                        .music_note, // You can change the icon to something else
                    size: 80,
                    color: Colors.deepPurple.shade300, // Icon color
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mezemur App',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Version: 1.0.0',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '''
        የኦርቶዶክስ መዝሙራት ይህ  
        በልዑል እግዚአብሔር ፈቃድና እርዳታየተሠራ
        የኢ/ኦ/ተ/ቤ/ክርስትያን በጅማ ቅዱስ ገብርኤል ግቢ ጉባኤ 
        መዝሙር ክፍል የተዘጋጁ የጥራዝ መዝሙራት ግጥም እና ዜማ 
        የሚቀርብበት የሞባይል መተግበሪያ (አፕ) ነው። አስተያየትዎንና ጥያቄዎን
        በኢሜል አድራሻችን jitgibigubae@gmail.com ሊልኩልን ይችላሉ።

              ''',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality here
                    },
                    child: Text('Learn More'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          Colors.deepPurple.shade300, // Button background color
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded button
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
