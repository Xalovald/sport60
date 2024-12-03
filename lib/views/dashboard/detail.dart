import 'package:flutter/material.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/domain/planning_domain.dart';

class DetailDashboard extends StatefulWidget {
  final int sessionId;
  const DetailDashboard({required this.sessionId, super.key});

  @override
  State<DetailDashboard> createState() => _DetailDashboardState();
}

class _DetailDashboardState extends State<DetailDashboard> {
  final SessionService _sessionService = SessionService();
  final SessionExerciseService _sessionExerciseService = SessionExerciseService();
  final PlanningService _planningService = PlanningService();

  SessionDomain? _session;
  List<SessionExerciseDomain> _sessionExercises = [];
  PlanningDomain? _planning;

  @override
  void initState() {
    super.initState();
    _loadSession();
    _loadSessionExercises();
    _loadPlanning();
  }

  void _loadSession() async {
    SessionDomain session = await _sessionService.getSessionById(widget.sessionId);
    setState(() {
      _session = session;
    });
  }

  void _loadSessionExercises() async {
    List<SessionExerciseDomain> sessionExercises = await _sessionExerciseService.getSessionExercisesBySessionId(widget.sessionId);
    setState(() {
      _sessionExercises = sessionExercises;
    });
  }

  void _loadPlanning() async {
    PlanningDomain planning = await _planningService.getPlanningBySessionId(widget.sessionId);
    setState(() {
      _planning = planning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la Session"),
        backgroundColor: const Color.fromARGB(255, 194, 167, 240),
      ),
      body: _session == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSessionDetails(),
                  const SizedBox(height: 20),
                  _buildSessionExercises(),
                ],
              ),
            ),
    );
  }

  Widget _buildSessionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _session!.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text('Réalisé le : ${_planning!.dateRealized} à ${_planning!.timeRealized}'),
        Text('Durée totale : ${_session!.totalDuration} secondes'),
      ],
    );
  }

  Widget _buildSessionExercises() {
    if (_sessionExercises.isEmpty) {
      return const Center(child: Text('Aucun exercice dans cette session.'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _sessionExercises.length,
        itemBuilder: (context, index) {
          final exercise = _sessionExercises[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(exercise.exerciseName ?? ""),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _session!.sessionTypeId == 1 ? 
                      "Répétitions: ${_sessionExercises[index].repetitions}, séries: ${_sessionExercises[index].series}" 
                    : _session!.sessionTypeId == 2 ?
                      "Durée: ${_sessionExercises[index].duration} sec, séries: ${_sessionExercises[index].series}, pause entre exercices: ${_sessionExercises[index].exercisePauseTime}, pause entre séries ${_sessionExercises[index].seriePauseTime}"
                    : 
                      "Répétitions: ${_sessionExercises[index].repetitions}, séries: ${_sessionExercises[index].series}, pause entre séries: ${_sessionExercises[index].seriePauseTime}",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
