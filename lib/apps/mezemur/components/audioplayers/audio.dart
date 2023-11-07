import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    required this.audioUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();
  Timer? _timer;
  Future<bool>? _audioDownloaded;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
    _audioDownloaded = _checkIfAudioDownloaded();
    _audioPlayer.pause();
    _position = _duration;
    _audioPlayer.pause();
    _stopTimer();
  }

  Future<bool> _checkIfAudioDownloaded() async {
    final fileName = widget.audioUrl.split('/').last;
    final appDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDirectory.path}/$fileName';
    final file = File(filePath);

    return file.existsSync();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      _onComplete();
    });

    final fileName = widget.audioUrl.split('/').last;
    final appDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDirectory.path}/$fileName';
    final file = File(filePath);

    if (file.existsSync()) {
      _isDownloaded = true; // Set _isDownloaded to true if the file exists
      _setSourceUrlAndPlay(filePath);
    } else {
      // Auto-downloading is removed
    }
  }

  void _setSourceUrlAndPlay(String url) async {
    await _audioPlayer.setSourceUrl(url);
    if (_isDownloaded) {
      _startTimer();
    }
  }

  Future<void> _downloadAudio() async {
    final fileName = widget.audioUrl.split('/').last;
    final appDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDirectory.path}/$fileName';
    final file = File(filePath);

    if (!file.existsSync()) {
      try {
        final dio = Dio();
        await dio.download(widget.audioUrl, filePath);
        setState(() {
          _isDownloaded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$widget.audioUrl downloaded'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading audio'),
          ),
        );
      }
    }
  }

  void _onComplete() {
    setState(() {
      _position = _duration;
      isPlaying = false;
      _isDownloaded =
          false; // Reset _isDownloaded to false when audio completes
    });
    _timer?.cancel();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_position < _duration) {
        setState(() {
          _position += const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _playPause() {
    if (isPlaying) {
      _audioPlayer.pause();
      _stopTimer();
    } else {
      _audioPlayer.resume();
      _startTimer();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _seekBackward() {
    final newPosition = _position - const Duration(seconds: 10);
    _audioPlayer.seek(newPosition);
    setState(() {
      _position = newPosition;
    });
  }

  void _seekForward() {
    final newPosition = _position + const Duration(seconds: 10);
    _audioPlayer.seek(newPosition);
    setState(() {
      _position = newPosition;
    });
  }

  String _positionToString(Duration position) {
    final hours = position.inHours.toString().padLeft(2, '0');
    final minutes = (position.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (position.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    double containerHeight = screenHeight * 0.20;
    double iconsize = (screenHeight + screenwidth) * 0.03;
    double iconsize2 = (screenHeight + screenwidth) * 0.035;
    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble(),
            activeColor: const Color.fromRGBO(26, 144, 157, 1.0),
            inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState(() {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
                _position = Duration(seconds: value.toInt());
                _audioPlayer.pause();
              });
            },
          ),
          Center(
            child: Text(
              '${_positionToString(_position)} / ${_positionToString(_duration)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _position > Duration.zero ? _seekBackward : null,
                icon: Icon(Icons.replay_10),
                iconSize: iconsize,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              IconButton(
                onPressed: _playPause,
                icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
                iconSize: iconsize2,
                color: Color.fromRGBO(26, 144, 157, 1.0),
              ),
              IconButton(
                onPressed: _position < _duration ? _seekForward : null,
                icon: Icon(Icons.forward_10),
                iconSize: iconsize,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
          // const SizedBox(height: 13.0),
          FutureBuilder<bool>(
            future: _audioDownloaded,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text(
                  'Error loading audio',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.red,
                  ),
                );
              } else if (snapshot.data == true) {
                return ElevatedButton(
                  onPressed: () {
                    // Play the downloaded audio manually.
                    _setSourceUrlAndPlay(widget.audioUrl);
                  },
                  child: Text('Play Downloaded Audio'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(26, 144, 157, 1.0),
                    textStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    // Manually download the audio when the button is pressed.
                    _downloadAudio();
                  },
                  child: Text('Download Audio'),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(26, 144, 157, 1.0),
                    textStyle: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
