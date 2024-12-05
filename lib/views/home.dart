import 'package:flutter/material.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/commentary.dart';
import 'package:sport60/widgets/commentaryGet.dart';
import 'package:sport60/widgets/stopwatch.dart';
import 'package:sport60/widgets/timer.dart';
import 'package:sport60/widgets/sound.dart';
import 'package:sport60/views/planning/choose_session.dart';
import 'package:sport60/widgets/theme.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: themeNotifier.currentTheme.primaryColor,
          foregroundColor: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
        ),
        body: Column(children: [
          const Text("Home"),
          CustomButton(
            onClick: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ChooseSession()))
            },
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: themeNotifier.currentTheme.colorScheme.primary,
                border: Border.all(width: 2)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            heroTag: 'ChooseSessionButton',
            child: Text(
              "Planifier une séance",
              style: TextStyle(
                //apply cutom button color
                color: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
              ),
            ),
          ),
          StopwatchWidget(),
          CountdownTimer(
            maxTime: 5,
            onTimeUp: () {
              print('Temps écoulé!');
            },
            autoStart: false,
          ),
          Expanded(child: CommentListWidget(sessionId: 1, exerciseId: 2)),
        ]));
  }
}
