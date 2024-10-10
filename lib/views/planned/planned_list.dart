import 'package:flutter/material.dart';

class PlannedList extends StatefulWidget {
  const PlannedList({super.key});
  @override
  State<PlannedList> createState() => _PlannedListState();
}

class _PlannedListState extends State<PlannedList> {
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
