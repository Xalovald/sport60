import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class SoundWidget extends StatefulWidget {
  final String assetPath;
  final Duration duration;

  SoundWidget({required this.assetPath, required this.duration});

  @override
  _SoundWidgetState createState() => _SoundWidgetState();

  static Future<void> playSound(String assetPath, Duration duration) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    try {
      await audioPlayer.play(AssetSource(assetPath));
      print('Sound played successfully.');
      await Future.delayed(duration);
      await audioPlayer.stop();
      print('Sound stopped after duration.');
    } catch (e) {
      print('Error playing sound: $e');
    } finally {
      audioPlayer.dispose();
    }
  }
}

class _SoundWidgetState extends State<SoundWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _playSound();
  }

  void _playSound() async {
    try {
      await _audioPlayer.play(AssetSource(widget.assetPath));
      print('Sound played successfully.');

      _timer = Timer(widget.duration, () {
        _audioPlayer.stop();
        print('Sound stopped after duration.');
      });
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Le widget peut être vide car il est utilisé pour jouer le son
  }
}
