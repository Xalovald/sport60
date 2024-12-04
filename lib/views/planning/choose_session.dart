import 'package:flutter/material.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/views/planning/create.dart';
import 'package:sport60/views/session/create.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/sound.dart';
import 'package:sport60/widgets/theme.dart';
import 'package:provider/provider.dart';

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choisir une séance"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 194, 167, 240),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sélectionnez ou ajoutez une séance",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.deepPurple, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SessionDomain>(
                  hint: const Text(
                    "Sélectionner une séance",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  value: _selectedSession,
                  onChanged: (SessionDomain? newValue) {
                    setState(() {
                      _selectedSession = newValue;
                    });
                    if (newValue != null) {
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
                      child: Text(
                        session.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              onClick: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateSession()),
                )
              },
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.deepPurple.shade800, width: 2),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              heroTag: 'CreateSession',
              child: Text(
                "Ajouter une séance",
                style: TextStyle(
                  color: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
