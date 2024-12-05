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
import 'package:sport60/widgets/button.dart';

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
    if (_session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isStrarted) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Création de la séance'),
          backgroundColor: const Color.fromARGB(255, 194, 167, 240),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Commencer votre séance ${_session!.name}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Appuyez sur le bouton ci-dessous pour commencer !',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  onClick: () {
                    setState(() {
                      _isStrarted = true;
                    });
                  },
                  heroTag: 'Start',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
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
                  child: const Text(
                    "Démarrer",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_isSessionTerminate) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Création de la séance'),
          backgroundColor: const Color.fromARGB(255, 194, 167, 240),
        ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Text('Séance terminée'),
        //       if(_session!.sessionTypeId == 1)
        //         TextFormField(
        //           decoration: const InputDecoration(labelText: 'Combien de série avez vous réalisé?'),
        //           keyboardType: TextInputType.number,
        //           onChanged: (value) {
        //             setState(() {
        //               _nbSeriesRealised = int.tryParse(value) ?? 1;
        //             });
        //           },
        //         ),
        //       ElevatedButton(
        //         onPressed: () async {
        //           await _updateSession();

        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => DetailDashboard(sessionId: _session!.id!),
        //             ),
        //           );
        //         },
        //         child: const Text('Voir le récap'),
        //       ),
        //     ],
        //   ),
        // ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Séance terminée ${_session!.name}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if(_session!.sessionTypeId == 1) ...[
                  const Text(
                    'Entrer votre nombre de série réalisé puis cliquer sur le bouton pour voir le récapitulatif de votre séance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Nombre de série réalisé ?",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _nbSeriesRealised = int.tryParse(value) ?? 1;
                      });
                    },
                  ),
                ] else ...[
                  const Text(
                    'Cliquer sur le bouton pour voir le récapitulatif de votre séance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                
                const SizedBox(height: 30),

                CustomButton(
                  onClick: () async {
                    await _updateSession();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDashboard(sessionId: _session!.id!),
                      ),
                    );
                  },
                  heroTag: 'Recap',
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
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
                  child: const Text(
                    "Voir le récap",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }



    final currentExercise = _sessionExercises.isNotEmpty
        ? _sessionExercises[_currentExerciseIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Création de la séance'),
        backgroundColor: const Color.fromARGB(255, 194, 167, 240),
      ),
      body: _session == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_session!.sessionTypeId == 1) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: CountdownTimer(
                      maxTime: _session!.totalDuration,
                      onTimeUp: () {
                        _showSessionCompleteDialog();
                        setState(() {
                          _isSessionTerminate = true;
                        });
                      },
                      autoStart: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Effectuer autant de tours d'exercices que possible",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: ListView.builder(
                        itemCount: _sessionExercises.length,
                        itemBuilder: (context, index) {
                          final sessionExercise = _sessionExercises[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                "Exercice: ${sessionExercise.exerciseName}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Nombre de répétitions: ${sessionExercise.repetitions}",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ] else if (_session!.sessionTypeId == 2) ...[
                  if (currentExercise != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StopwatchWidget(
                          key: _stopwatchKey,
                          onStop: handleStopwatchStop,
                          autoStart: true,
                        ),

                        const SizedBox(height: 150),
                        
                        Text(
                          _isResting
                              ? "Repos : ${_currentSeries == currentExercise.series ? currentExercise.exercisePauseTime : currentExercise.seriePauseTime}s"
                              : "Exercice : ${currentExercise.exerciseName}",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isResting ? Colors.green : Colors.blue,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        
                        if (_isResting) ...[
                          CountdownTimer(
                            key: ValueKey('pause-${_currentExerciseIndex}-${_currentSeries}'),
                            maxTime: _currentSeries == currentExercise!.series
                                ? currentExercise.exercisePauseTime ?? 0
                                : currentExercise.seriePauseTime,
                            onTimeUp: _startNextStep,
                            autoStart: true,
                          ),
                        ] else if (currentExercise != null && (currentExercise.duration ?? 0) > 0) ...[
                          CountdownTimer(
                            key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                            maxTime: currentExercise.duration ?? 0,
                            onTimeUp: _startNextStep,
                            autoStart: true,
                          ),
                        ],
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Série ${_currentSeries} / ${currentExercise!.series}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                            ),
                            Text(
                              "Exercice ${_currentExerciseIndex + 1} / ${_sessionExercises.length}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ] else if (_session!.sessionTypeId == 3) ...[
                  if (currentExercise != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StopwatchWidget(
                          key: _stopwatchKey,
                          onStop: handleStopwatchStop,
                          autoStart: true,
                        ),

                        const SizedBox(height: 150),
                        
                        Text(
                          _isResting
                              ? "Repos : ${_currentSeries == currentExercise.series ? currentExercise.exercisePauseTime : 0}s"
                            : "Exercice : ${currentExercise.repetitions} ${currentExercise.exerciseName}",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isResting ? Colors.green : Colors.blue,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        
                        if (_isResting) ...[
                          CountdownTimer(
                            key: ValueKey('pause-${_currentExerciseIndex}-${_currentSeries}'),
                            maxTime: _currentSeries == currentExercise!.series
                                ? currentExercise.exercisePauseTime ?? 0
                                : 0,
                            onTimeUp: _startNextStep,
                            autoStart: true,
                          ),
                        ] else ...[
                          CountdownTimer(
                            key: ValueKey('exercise-${_currentExerciseIndex}-${_currentSeries}'),
                            maxTime: 60,
                            onTimeUp: _startNextStep,
                            autoStart: true,
                          ),
                        ],
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Série ${_currentSeries} / ${currentExercise!.series}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                            ),
                            Text(
                              "Exercice ${_currentExerciseIndex + 1} / ${_sessionExercises.length}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ]
              ],
            ),
    );
  }
}
