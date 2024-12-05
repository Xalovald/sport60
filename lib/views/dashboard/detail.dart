import 'package:flutter/material.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/widgets/commentary.dart';
import 'package:sport60/widgets/commentaryGet.dart';
import 'package:provider/provider.dart';
import 'package:sport60/widgets/theme.dart';

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
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la Session"),
        backgroundColor: themeNotifier.currentTheme.primaryColor,
        foregroundColor: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
      ),
      body: _session == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildSessionDetails(),
                    const SizedBox(height: 20),
                    _buildSessionExercises(),
                    
                    const SizedBox(height: 50),
                    CommentListWidget(
                      sessionId: _session!.id!,
                    ),

                    const SizedBox(height: 30),

                    CommentWidget(
                      sessionId: _session!.id!,
                    )
                  ],
                ),
              ),
            )
    );
  }

  Widget _buildSessionDetails() {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _session!.name,
          style: TextStyle(
            fontSize: 35, 
            fontWeight: FontWeight.bold,
            color: themeNotifier.currentTheme.textTheme.bodyMedium?.color,
          ),
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
    );
  }
}