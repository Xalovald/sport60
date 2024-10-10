import 'package:flutter/material.dart';

class PlanningList extends StatefulWidget {
  const PlanningList({super.key});
  @override
  State<PlanningList> createState() => _PlanningListState();
}

class _PlanningListState extends State<PlanningList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planned'),
      ),
      body: 
        const Text("Planned")
    );
  }
}
