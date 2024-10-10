import 'package:flutter/material.dart';
import 'package:sport60/services/exercise_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/exercise_domain.dart';

class PlanningCreate extends StatefulWidget {
  final SessionDomain session;

  const PlanningCreate({required this.session, super.key});

  @override
  State<PlanningCreate> createState() => _PlanningCreateState();
}

class _PlanningCreateState extends State<PlanningCreate> {
  final ExerciseService _exerciseService = ExerciseService();
  List<ExerciseDomain> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Récupérer les exercices de la séance sélectionnée
  Future<void> _loadExercises() async {
    List<ExerciseDomain> exercises = await _exerciseService.getExercisesBySessionId(widget.session.id!);
    setState(() {
      _exercises = exercises;
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
              "Durée: ${widget.session.totalDuration} minutes",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Exercices:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Afficher la liste des exercices
            _exercises.isEmpty
                ? const Text("Aucun exercice disponible.")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_exercises[index].name),
                        subtitle: Text(
                            "Répétitions: ${_exercises[index].repetitions}, Durée: ${_exercises[index].duration} minutes"),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
