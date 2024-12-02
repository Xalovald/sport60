import 'package:flutter/material.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/stopwatch.dart';
import 'package:sport60/widgets/timer.dart';
import 'package:sport60/widgets/sound.dart';
import 'package:sport60/views/planning/choose_session.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(children: [
          const Text("Home"),
          CustomButton(
            onClick: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const ChooseSession()))
            },
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: const Color.fromARGB(255, 224, 176, 255),
                border: Border.all(width: 2)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: 50,
            heroTag: 'ChooseSessionButton',
            child: const Text(
              "Planifier une séance",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          StopwatchWidget(),
          CountdownTimer(
            maxTime: 5,
            onTimeUp: () {
              print('Temps écoulé!');
            },
          ),
        ]));
  }
}
