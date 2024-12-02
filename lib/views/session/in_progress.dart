import 'dart:ffi';

import 'package:flutter/material.dart';

class InProgressSession extends StatefulWidget {
  final int sessionId;

  const InProgressSession({required this.sessionId ,super.key});

  @override
  State<InProgressSession> createState() => _InProgressSessionState();
}

class _InProgressSessionState extends State<InProgressSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Séance en cours'),
      ),
      body: 
        const Text("test")
    );
  }
}