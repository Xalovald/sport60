import 'package:flutter/material.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/widgets/timer.dart';
import 'package:sport60/widgets/stopwatch.dart';
import 'package:sport60/views/dashboard/detail.dart';
import 'package:provider/provider.dart';
import 'package:sport60/widgets/theme.dart';

class InProgressSession extends StatefulWidget {
  final int sessionId;

  const InProgressSession({required this.sessionId, super.key});

  @override
  State<InProgressSession> createState() => _InProgressSessionState();
}

class _InProgressSessionState extends State<InProgressSession> {
  final GlobalKey<StopwatchWidgetState> _stopwatchKey = GlobalKey();
  int _totalDuration = 0;

  final SessionService _sessionService = SessionService();
  final SessionExerciseService _sessionExerciseService = SessionExerciseService();
  final PlanningService _planningService = PlanningService();

  SessionDomain? _session;
  List<SessionExerciseDomain> _sessionExercises = [];
  int _currentExerciseIndex = 0;
  int _currentSeries = 1;
  bool _isResting = false;
  bool _isSessionTerminate = false;
  int _nbSeriesRealised = 0;

  bool _isStrarted = false;

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
          _stopwatchKey.currentState?.stopStopwatch();
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

  Future<void> _updateSession() async {
    PlanningDomain planning = await _planningService.getPlanningBySessionId(widget.sessionId);
    DateTime now = DateTime.now(); // Récupère la date et l'heure actuelles

    planning.dateRealized = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    planning.timeRealized = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    await _planningService.updatePlanning(planning);

    if(_session!.sessionTypeId == 1){
      for (var sessionExercise in _sessionExercises) {
        sessionExercise.series = _nbSeriesRealised; 
        await _sessionExerciseService.updateSessionExercise(sessionExercise);
      }
    }
    else{
      final session = SessionDomain(
        id: _session!.id,
        name: _session!.name,
        sessionTypeId: _session!.sessionTypeId,
        totalDuration: _totalDuration,
        pauseDuration: 0,
      );
      await _sessionService.updateSession(session);
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

  void handleStopwatchStop(int elapsedMilliseconds) {
    setState(() {
      _totalDuration = (elapsedMilliseconds / 1000).truncate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    if (_session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isStrarted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Séance en cours')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Démarer la séance !'),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isStrarted = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeNotifier.customButtonColor,
                ),
                child: const Text('Démarrer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_isSessionTerminate) {
      return Scaffold(
        appBar: AppBar(title: const Text('Séance en cours')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Séance terminée'),
              if(_session!.sessionTypeId == 1)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Combien de série avez vous réalisé?',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeNotifier.currentTheme.colorScheme.secondary,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: themeNotifier.currentTheme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _nbSeriesRealised = int.tryParse(value) ?? 1;
                    });
                  },
                ),
              ElevatedButton(
                onPressed: () async {
                  await _updateSession();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailDashboard(sessionId: _session!.id!),
                    ),
                  );
                },
                child: const Text('Voir le récap'),
              ),
            ],
          ),
        ),
      );
    }



    final currentExercise = _sessionExercises.isNotEmpty
        ? _sessionExercises[_currentExerciseIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Séance en cours'),
        backgroundColor: themeNotifier.currentTheme.primaryColor,
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
                    autoStart: true,
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
                      StopwatchWidget(
                        key: _stopwatchKey, // Passez la clé au widget
                        onStop: handleStopwatchStop,
                        autoStart: true,
                      ),
                      Text(
                        _isResting
                            ? "Repos : ${_currentSeries == currentExercise!.series ? currentExercise.exercisePauseTime : currentExercise.seriePauseTime}s"
                            : "Exercice : ${currentExercise!.exerciseName}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      if (_isResting) ...[
                        CountdownTimer(
                          key: ValueKey('pause-${_currentExerciseIndex}-${_currentSeries}'),
                          // maxTime: currentExercise!.exercisePauseTime ?? 0,
                          maxTime: _currentSeries == currentExercise!.series ? currentExercise.exercisePauseTime ?? 0 : currentExercise.seriePauseTime,
                          onTimeUp: _startNextStep,
                          autoStart: true,
                        )
                      ] else if (currentExercise != null && (currentExercise.repetitions ?? 0) > 0) ...[
                        Text("Effectuer ${currentExercise.repetitions}"),
                        ElevatedButton(
                          onPressed: _startNextStep,
                          child: Text('Terminé'),
                        )
                      ] else if (currentExercise != null && (currentExercise.duration ?? 0) > 0) ...[
                        CountdownTimer(
                          key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                          maxTime: currentExercise.duration ?? 0,
                          onTimeUp: _startNextStep,
                          autoStart: true,
                        ),
                      ],
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
                      StopwatchWidget(
                        key: _stopwatchKey, // Passez la clé au widget
                        onStop: handleStopwatchStop,
                        autoStart: true,
                      ),
                      Text(
                        _isResting
                            ? "Repos : ${currentExercise!.seriePauseTime}s"
                            : "Exercice : ${currentExercise!.exerciseName}, x${currentExercise.repetitions} reps",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    const SizedBox(height: 20),
                    if (_isResting)
                      CountdownTimer(
                        key: ValueKey('serie-pause-${_currentExerciseIndex}-${_currentSeries}'),
                        maxTime: currentExercise!.seriePauseTime,
                        onTimeUp: _startNextStep,
                        autoStart: true,
                      )
                    else
                      CountdownTimer(
                        key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                        maxTime: 60,
                        onTimeUp: _startNextStep,
                        autoStart: true,
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
