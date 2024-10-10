import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final int maxTime; // Time in seconds
  final Function onTimeUp;

  CountdownTimer({required this.maxTime, required this.onTimeUp, Key? key})
      : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingTime;
  Timer? timer;
  bool isStarted = false; // Track whether the timer has started

  @override
  void initState() {
    super.initState();
    remainingTime = widget.maxTime;
  }

  void startTimer() {
    setState(() {
      isStarted = true; // Update state to indicate the timer has started
    });
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        widget.onTimeUp();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Time remaining: $remainingTime seconds',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        // Show the button only if the timer hasn't started yet
        if (!isStarted)
          ElevatedButton(
            onPressed: startTimer,
            child: Text('Démarrer'), // Button to start the timer
          ),
      ],
    );
  }
}
