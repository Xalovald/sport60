import 'package:flutter/material.dart';

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
        const Text("History")
    );
  }
}
