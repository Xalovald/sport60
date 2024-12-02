import 'package:flutter/material.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';

class PlanningCreate extends StatefulWidget {
  final SessionDomain session;

  const PlanningCreate({required this.session, super.key});

  @override
  State<PlanningCreate> createState() => _PlanningCreateState();
}

class _PlanningCreateState extends State<PlanningCreate> {
  final SessionExerciseService _sessionExerciseService = SessionExerciseService();
  List<SessionExerciseDomain> _sessionExercises = [];

  @override
  void initState() {
    super.initState();
    _loadSessionExercises();
  }

  // Récupérer les exercices de la séance sélectionnée
  Future<void> _loadSessionExercises() async {
    List<SessionExerciseDomain> sessionExercises = await _sessionExerciseService.getSessionExercisesBySessionId(widget.session.id!);
    setState(() {
      _sessionExercises = sessionExercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Nom: ${widget.session.name}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Durée: ${widget.session.totalDuration} secondes",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exercices:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Afficher la liste des exercices
            _sessionExercises.isEmpty
                ? const Text("Aucun exercice disponible.")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sessionExercises.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_sessionExercises[index].exerciseName!),
                        subtitle: Text(
                            "Répétitions: ${_sessionExercises[index].repetitions}, Durée: ${_sessionExercises[index].duration} secondes, nb séries: ${_sessionExercises[index].series}, pause exercice: ${_sessionExercises[index].exercisePauseTime} secondes, pause série: ${_sessionExercises[index].seriePauseTime} secondes"),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
