import 'package:flutter/material.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/views/planning/create.dart';
import 'package:sport60/views/session/create.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/sound.dart';

class ChooseSession extends StatefulWidget {
  const ChooseSession({super.key});

  @override
  State<ChooseSession> createState() => _ChooseSessionState();
}

class _ChooseSessionState extends State<ChooseSession> {
  final SessionService _sessionService = SessionService();
  List<SessionDomain> _sessions = [];
  SessionDomain? _selectedSession;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    List<SessionDomain> sessions = await _sessionService.getSession();
    setState(() {
      _sessions = sessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir une séance"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // DropdownButton pour afficher les séances
            DropdownButton<SessionDomain>(
              hint: const Text("Sélectionner une séance"),
              value: _selectedSession,
              onChanged: (SessionDomain? newValue) {
                setState(() {
                  _selectedSession = newValue;
                });
                if (newValue != null) {
                  // Naviguer vers la page de détails
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlanningCreate(session: newValue),
                    ),
                  );
                }
              },
              items: _sessions.map<DropdownMenuItem<SessionDomain>>(
                  (SessionDomain session) {
                return DropdownMenuItem<SessionDomain>(
                  value: session,
                  child: Text(session.name),
                );
              }).toList(),
            ),

            CustomButton(
              onClick: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CreateSession()))
              },
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: const Color.fromARGB(255, 224, 176, 255),
                  border: Border.all(width: 2)),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              heroTag: 'CreateSession',
              child: const Text(
                "Ajouter une séance",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
