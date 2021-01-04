import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: DashCastApp()),
    );
  }
}

class DashCastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 9,
          child: Placeholder(),
        ),
        Flexible(
          flex: 2,
          child: AudioControls(),
        ),
      ],
    );
  }
}

class AudioControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PlaybackButtons(),
      ],
    );
  }
}

class PlaybackButtons extends StatefulWidget {
  @override
  _PlaybackButtonState createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButtons> {
  bool _isPlaying = false;
  FlutterSound flutterSound;
  String url =
      'https://incompetech.com/music/royalty-free/mp3-royaltyfree/Surf%20Shimmy.mp3';
  double playPosition;
  Stream<PlayStatus> _playerSubscription;

  void _stop() async {
    await flutterSound.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  void _play() async {
    await flutterSound.startPlayer(url);
    _playerSubscription = flutterSound.onPlayerStateChanged
      ..listen((e) {
        if (e != null) {
          setState(() => playPosition = e.currentPosition / e.duration);
        }
      });
    setState(() {
      _isPlaying = true;
    });
  }

  void _fastForward() {}

  void _rewind() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Slider(value: this.playPosition),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.fast_rewind), onPressed: null),
            IconButton(
              icon: _isPlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
              onPressed: () {
                if (_isPlaying) {
                  _stop();
                } else {
                  _play();
                }
              },
            ),
            IconButton(icon: Icon(Icons.fast_forward), onPressed: null),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    playPosition = 0.0;
    flutterSound = new FlutterSound();
  }

  @override
  void dispose() {
    flutterSound.stopPlayer();
    super.dispose();
  }
}
