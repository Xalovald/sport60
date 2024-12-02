import 'package:flutter/material.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/views/planning/choose_session.dart';


class HistoryList extends StatefulWidget {
  const HistoryList({super.key});
  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: 
        Column(
          children: [ 
            const Text("History"),
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
            )
          ],
        )
    );
  }
}
