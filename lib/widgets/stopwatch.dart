import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<String> _savedTimes = [];

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {});
  }

  void _saveAndRestart() {
    setState(() {
      _savedTimes.add(_formatTime(_stopwatch.elapsedMilliseconds));
    });

    _resetStopwatch();
    _startStopwatch();
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr:$hundredsStr";
  }

  @override
  Widget build(BuildContext context) {
    final String elapsedTime = _formatTime(_stopwatch.elapsedMilliseconds);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          elapsedTime,
          style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_stopwatch.isRunning) {
                    _stopStopwatch();
                  } else {
                    _startStopwatch();
                  }
                });
              },
              child: Text(_stopwatch.isRunning ? 'Arrêt' : 'Marche'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _saveAndRestart,
              child: Text('Suivant'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _savedTimes.map((time) => Text('- Drapeau: $time')).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
