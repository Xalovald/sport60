import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  final Function(int elapsedMilliseconds)? onStop;
  final bool autoStart;

  const StopwatchWidget({Key? key, this.onStop, this.autoStart = false}) : super(key: key);

  @override
  StopwatchWidgetState createState() => StopwatchWidgetState();
}

class StopwatchWidgetState extends State<StopwatchWidget> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    if (widget.autoStart) {
      _startStopwatch();
    }
  }

  void _startStopwatch() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  void stopStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      if (widget.onStop != null) {
        widget.onStop!(_stopwatch.elapsedMilliseconds);
      }
    }
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
            if(!_stopwatch.isRunning)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _startStopwatch();
                  });
                },
                child: const Text('Marche'),
              ),
          ],
        ),
      ],
    );
  }

}
