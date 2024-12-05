import 'package:flutter/material.dart';
import 'package:sport60/widgets/sound.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int maxTime;
  final VoidCallback onTimeUp;
  final bool autoStart;

  CountdownTimer(
      {required this.maxTime, required this.onTimeUp, this.autoStart = false, super.key});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  int _remainingTime = 0;
  bool _isStarted = false;
  Timer? _timer; // Changed from late Timer to Timer? and initialized with null
  final SoundWidget _soundWidget = SoundWidget(
    assetPath: 'sounds/time_up.mp3',
    duration: Duration(seconds: 14), // Durée maximale de lecture
    schedule: Duration(seconds: 0), // Temps avant démarrage de la sonnerie
  );

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.maxTime;
    if (widget.autoStart) {
      startTimer();
    }
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
          _timer?.cancel();
          widget.onTimeUp();
          _playSound();
        }
      });
    });
  }

  void _playSound() {
    setState(() {
      _isStarted =
          true; // Etat permettant de redémarrer ou non le compte à rebours
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _remainingTime > 0
              ? '$_remainingTime'
              : '0',
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        if (!_isStarted && !widget.autoStart)
          ElevatedButton(
            onPressed: startTimer,
            child: Text('Démarrer'),
          ),
        if (_remainingTime == 0)
          _soundWidget, // Ajoutez _soundWidget à l'arbre des widgets lorsque le temps est écoulé
      ],
    );
  }
}