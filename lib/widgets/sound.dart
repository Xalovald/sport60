import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class SoundWidget extends StatefulWidget {
  final String assetPath;
  final Duration duration;
  final Duration schedule;

  SoundWidget({
    required this.assetPath,
    required this.duration,
    required this.schedule,
  });

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
  bool _isPlaying =
      false; // Variable pour suivre si une musique est en cours de lecture

  @override
  void initState() {
    super.initState();
    scheduleSound(widget.schedule);
  }

  void scheduleSound(Duration delay) {
    _timer?.cancel(); // Annule tout timer existant
    _timer = Timer(delay, () {
      _playSound();
    });
  }

  void _playSound() async {
    if (_isPlaying) {
      print('Another sound is already playing.');
      return; // Ignore la nouvelle demande de lecture si une musique est déjà en cours
    }

    _isPlaying = true; // Marque que la musique est en cours de lecture

    try {
      await _audioPlayer.play(AssetSource(widget.assetPath));
      print('Sound played successfully.');

      _timer = Timer(widget.duration, () {
        _audioPlayer.stop();
        print('Sound stopped after duration.');
        _isPlaying = false; // Marque que la musique a fini de jouer
      });
    } catch (e) {
      print('Error playing sound: $e');
      _isPlaying =
          false; // Marque que la musique a fini de jouer en cas d'erreur
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
