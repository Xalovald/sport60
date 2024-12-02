import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import "dart:async";

class CountdownTimer extends StatefulWidget {
  final int maxTime;
  final VoidCallback onTimeUp;

  CountdownTimer({required this.maxTime, required this.onTimeUp});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _remainingTime = 0;
  bool _isStarted = false;
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.maxTime;
  }

  void startTimer() {
    setState(() {
      _isStarted = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          widget.onTimeUp();
          _playSound();
        }
      });
    });
  }

  void _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/time_up.mp3'));
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _remainingTime > 0
              ? 'Temps restant: $_remainingTime secondes'
              : 'Temps écoulé!',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        if (!_isStarted)
          ElevatedButton(
            onPressed: startTimer,
            child: Text('Démarrer'),
          ),
      ],
    );
  }
}
