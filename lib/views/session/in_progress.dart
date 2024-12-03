import 'package:flutter/material.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/widgets/timer.dart';

class InProgressSession extends StatefulWidget {
  final int sessionId;

  const InProgressSession({required this.sessionId, super.key});

  @override
  State<InProgressSession> createState() => _InProgressSessionState();
}

class _InProgressSessionState extends State<InProgressSession> {
  final SessionService _sessionService = SessionService();
  final SessionExerciseService _sessionExerciseService = SessionExerciseService();

  SessionDomain? _session;
  List<SessionExerciseDomain> _sessionExercises = [];
  int _currentExerciseIndex = 0;
  int _currentSeries = 1;
  bool _isResting = false;
  bool _isSessionTerminate = false;

  @override
  void initState() {
    super.initState();
    _loadSession();
    _loadSessionExercises();
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

  void _startNextStep() {
    if (_isResting) {
      // Sortie de la phase de repos
      setState(() {
        _isResting = false;
      });

      if (_currentSeries >= _sessionExercises[_currentExerciseIndex].series) {
        // Passer à l'exercice suivant si toutes les séries sont terminées
        setState(() {
          _currentSeries = 1; // Réinitialiser les séries pour le prochain exercice
          _currentExerciseIndex++;
        });

        if (_currentExerciseIndex >= _sessionExercises.length) {
          _showSessionCompleteDialog();
          setState(() {
            _isSessionTerminate = true;
          });
          return;
        }
      } else {
        // Passer à la série suivante
        setState(() {
          _currentSeries++;
        });
      }
    } else {
      // Transition vers la phase de repos
      setState(() {
        _isResting = true;
      });
    }
  }


  void _showSessionCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Séance terminée'),
        content: const Text('Félicitations ! Vous avez terminé toutes les séries.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isSessionTerminate) {
      return Scaffold(
        appBar: AppBar(title: const Text('Séance en cours')),
        body: const Center(child: Text('Séance terminée')),
      );
    }

    final currentExercise = _sessionExercises.isNotEmpty
        ? _sessionExercises[_currentExerciseIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Séance en cours'),
      ),
      body: _session == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_session!.sessionTypeId == 1) ...[
                  CountdownTimer(
                    maxTime: _session!.totalDuration,
                    onTimeUp: () {
                      _showSessionCompleteDialog();
                      setState(() {
                        _isSessionTerminate = true;
                      });
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Effectuer autant de tours d'exercices que possible"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _sessionExercises.length,
                      itemBuilder: (context, index) {
                        final sessionExercise = _sessionExercises[index];
                        return ListTile(
                          title: Text("Exercice: ${sessionExercise.exerciseName}"),
                          subtitle: Text("Nombre de répétitions: ${sessionExercise.repetitions}"),
                        );
                      },
                    ),
                  ),
                ] else if (_session!.sessionTypeId == 2) ...[
                    if (currentExercise != null)
                      Text(
                        _isResting
                            ? "Repos : ${_currentSeries == currentExercise.series ? currentExercise.exercisePauseTime : currentExercise.seriePauseTime}s"
                            : "Exercice : ${currentExercise.exerciseName}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      if (_isResting)
                        CountdownTimer(
                          key: ValueKey('pause-${_currentExerciseIndex}-${_currentSeries}'),
                          // maxTime: currentExercise!.exercisePauseTime ?? 0,
                          maxTime: _currentSeries == currentExercise!.series ? currentExercise.exercisePauseTime ?? 0 : currentExercise.seriePauseTime,
                          onTimeUp: _startNextStep,
                        )
                      // else if (currentExercise!.repetitions > 0)
                      //   StopwatchWidget(
                      //     onStop: _startNextStep,
                      //   )
                      else if (currentExercise != null && (currentExercise.duration ?? 0) > 0)
                        CountdownTimer(
                          key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                          maxTime: currentExercise.duration ?? 0,
                          onTimeUp: _startNextStep,
                        ),
                      const SizedBox(height: 20),
                      Text(
                        "Série ${_currentSeries} / ${currentExercise!.series}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "Exercice ${_currentExerciseIndex + 1} / ${_sessionExercises.length}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                ] else if (_session!.sessionTypeId == 3) ...[
                  if (currentExercise != null)
                      Text(
                        _isResting
                            ? "Repos : ${currentExercise.seriePauseTime}s"
                            : "Exercice : ${currentExercise.exerciseName}, x${currentExercise.repetitions} reps",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    const SizedBox(height: 20),
                    if (_isResting)
                      CountdownTimer(
                        key: ValueKey('serie-pause-${_currentExerciseIndex}-${_currentSeries}'),
                        maxTime: currentExercise!.seriePauseTime,
                        onTimeUp: _startNextStep,
                      )
                    else
                      CountdownTimer(
                        key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                        maxTime: 60,
                        onTimeUp: _startNextStep,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      "Série ${_currentSeries} / ${currentExercise!.series}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "Exercice ${_currentExerciseIndex + 1} / ${_sessionExercises.length}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ]
              ],
            ),
    );
  }
}
