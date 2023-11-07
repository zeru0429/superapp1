import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMezemur extends StatelessWidget {
  const AboutMezemur({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize =
        MediaQuery.of(context).size.width * 0.05; // 5% of screen width
    double bannerSize =
        MediaQuery.of(context).size.width * 0.30; // 30% of screen width

    return Scaffold(
      backgroundColor: Colors.blue[100], // Background color
      body: Center(
        child: SingleChildScrollView(
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
                    Image.asset(
                      'assets/images/logo.png', // Replace with your image asset path
                      width: bannerSize,
                      height: bannerSize,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'የመዝሙር App',
                      style: TextStyle(
                        fontFamily: "jiret",
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version: 1.0.0',
                      style: TextStyle(
                        fontFamily: "jiret",
                        fontSize: fontSize * 0.7,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '''የኦርቶዶክስ መዝሙራት ይህ በልዑል እግዚአብሔር ፈቃድና እርዳታ የተሠራ የኢ/ኦ/ተ/ቤ/ክርስትያን በጅማ ቅዱስ ገብርኤል ግቢ ጉባኤ መዝሙር ክፍል የተዘጋጁ የጥራዝ መዝሙራት ግጥም እና ዜማ የሚቀርብበት የሞባይል መተግበሪያ (አፕ) ነው። አስተያየትዎንና ጥያቄዎን በኢሜል አድራሻችን jitgibigubae@gmail.com ሊልኩልን ይችላሉ።''',
                      style: TextStyle(
                        fontFamily: "jiret",
                        fontSize: fontSize * 0.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        const String telegramUrl =
                            'https://t.me/jitgibigubae'; // Replace with your Telegram link
                        final Uri uri = Uri.parse(telegramUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $telegramUrl';
                        }
                      },
                      icon: Icon(Icons
                          .send), // Use the Telegram icon or any other desired icon
                      label: Text(
                        'join telegram channel',
                        style: TextStyle(
                          fontFamily: 'jiret',
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(
                            255, 0, 130, 146), // Button background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
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
      ),
    );
  }
}
