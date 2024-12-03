import 'dart:math';

import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/exercise_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/domain/session_type_domain.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/services/session_type_service.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/exercise_service.dart';

class CreateSession extends StatefulWidget {
  const CreateSession({super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}
class _CreateSessionState extends State<CreateSession> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseFormKey = GlobalKey<FormState>();

  String? _sessionName;
  int? _sessionTypeId;
  int? _totalDuration;
  int? _selectedExerciseId;
  int _exerciseDuration = 0;
  int _exerciseRepetitions = 0;
  int _exerciseSeries = 1;
  int _exercisePauseTime = 0;
  int _exerciseSeriePauseTime = 0;
  List<SessionExerciseDomain> _sessionExercises = [];

  List<ExerciseDomain> _exercises = []; // Liste des exercices disponibles
  String? _newExerciseName;
  String? _newExerciseDescription;

  final SessionService _sessionService = SessionService();
  final SessionTypeService _sessionTypeService = SessionTypeService();
  final SessionExerciseService _sessionExerciseService = SessionExerciseService();
  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Charger les exercices existants depuis la base de données
  void _loadExercises() async {
    List<ExerciseDomain> exercises = await _exerciseService.getExercise();
    setState(() {
      _exercises = exercises;
    });
  }

  // Créer une session et ses exercices associés
  void _createSession() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Créer la session
      final session = SessionDomain(
        name: _sessionName!,
        sessionTypeId: _sessionTypeId!,
        totalDuration: _totalDuration ?? 0,
        //totalDuration: _sessionExercises.fold<int>(0, (sum, exercise) => sum + (exercise.duration ?? 0 * exercise.series),),
        pauseDuration: 0,
      );
      final sessionId = await _sessionService.addSession(session);

      // Créer les session_exercises
      for (var sessionExercise in _sessionExercises) {
        sessionExercise.sessionId = sessionId;  // Associer l'ID de la session
        await _sessionExerciseService.addSessionExercise(sessionExercise);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Session created successfully!')),
        );
      }
      // Reset fields
      setState(() {
        _sessionExercises.clear();
      });
    }
  }
  // Ajouter un exercice à la session
  void _addSessionExercise() async {
    if (_selectedExerciseId != null) {
      final exercise = await _exerciseService.getExerciseById(_selectedExerciseId!);

      setState(() {
        _sessionExercises.add(SessionExerciseDomain(
          sessionId: 0,  // Cette valeur sera mise à jour lors de la création de la session
          exerciseId: _selectedExerciseId!,
          duration: _exerciseDuration,
          repetitions: _exerciseRepetitions,
          series: _exerciseSeries,
          exercisePauseTime: _exercisePauseTime,
          seriePauseTime: _exerciseSeriePauseTime,
          exerciseName: exercise.name,
          exerciseDescription: exercise.description,
        ));
      });
    }
  }

  // Fonction pour ouvrir la fenêtre modale et ajouter un nouvel exercice
  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un nouvel exercice'),
          content: Form(
            key: _exerciseFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ pour le nom de l'exercice
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom de l\'exercice'),
                  onChanged: (value) {
                    setState(() {
                      _newExerciseName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom pour l\'exercice';
                    }
                    return null;
                  },
                ),
                // Champ pour la description de l'exercice
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description de l\'exercice'),
                  onChanged: (value) {
                    setState(() {
                      _newExerciseDescription = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description pour l\'exercice';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_exerciseFormKey.currentState!.validate()) {
                  // Créer un nouvel exercice
                  final newExercise = ExerciseDomain(
                    id: DateTime.now().millisecondsSinceEpoch, // Génère un ID unique
                    name: _newExerciseName!,
                    description: _newExerciseDescription!,
                  );

                  // Enregistrer l'exercice dans la base de données
                  await _exerciseService.addExercise(newExercise);

                  // Rechargez la liste des exercices
                  _loadExercises();

                  // Fermer la fenêtre modale
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Exercice ajouté avec succès!')),
                  );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Session name
                TextFormField(
                  decoration: InputDecoration(labelText: 'Session Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a session name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _sessionName = value;
                  },
                ),

                // Session type
                FutureBuilder<List<SessionTypeDomain>>(
                  future: _sessionTypeService.getSessionTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading session types');
                    }

                    final sessionTypes = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      decoration: InputDecoration(labelText: 'Session Type'),
                      value: _sessionTypeId,
                      items: sessionTypes
                          .map((type) => DropdownMenuItem<int>(
                                value: type.id,
                                child: Text(type.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _sessionTypeId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a session type';
                        }
                        return null;
                      },
                    );
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Total duration (s)'),
                  keyboardType: TextInputType.number,
                  enabled: _sessionTypeId == 1, 
                  onChanged: (value) {
                    setState(() {
                      _totalDuration = int.tryParse(value) ?? 0;
                    });
                  },
                ),

                SizedBox(height: 70),

                // Ajouter un nouvel exercice via le bouton
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: _showAddExerciseDialog,
                    child: Text('Ajouter un exercice'),
                  ),
                ),

                // Select exercise
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(labelText: 'Sélectionner un exercice'),
                  value: _selectedExerciseId,
                  items: _exercises
                      .map((exercise) => DropdownMenuItem<int>(
                            value: exercise.id,
                            child: Text(exercise.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExerciseId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un exercice';
                    }
                    return null;
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrer les éléments
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Duration (s)'),
                        keyboardType: TextInputType.number,
                        enabled: _exerciseRepetitions == 0 && _sessionTypeId == 2, // Désactivé si des répétitions sont définies
                        onChanged: (value) {
                          setState(() {
                            _exerciseDuration = int.tryParse(value) ?? 0;
                            if (_exerciseDuration > 0) {
                              _exerciseRepetitions = 0; // Réinitialise les répétitions
                            }
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('ou'),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Repetitions'),
                        keyboardType: TextInputType.number,
                        enabled: _exerciseDuration == 0, // Désactivé si la durée est définie
                        onChanged: (value) {
                          setState(() {
                            _exerciseRepetitions = int.tryParse(value) ?? 0;
                            if (_exerciseRepetitions > 0) {
                              _exerciseDuration = 0; // Réinitialise la durée
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),


                TextFormField(
                  decoration: InputDecoration(labelText: 'Series'),
                  keyboardType: TextInputType.number,
                  enabled: _sessionTypeId != 1,
                  onChanged: (value) {
                    setState(() {
                      _exerciseSeries = int.tryParse(value) ?? 1;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Pause entre exercice'),
                  keyboardType: TextInputType.number,
                  enabled: _sessionTypeId == 2,
                  onChanged: (value) {
                    setState(() {
                      _exercisePauseTime = int.tryParse(value) ?? 0;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'pause entre série'),
                  keyboardType: TextInputType.number,
                  enabled: _sessionTypeId != 1,
                  onChanged: (value) {
                    setState(() {
                      _exerciseSeriePauseTime = int.tryParse(value) ?? 0;
                    });
                  },
                ),

                // Add Exercise button
                ElevatedButton(
                  onPressed: _addSessionExercise,
                  child: Text('Add Exercise to Session'),
                ),

                SizedBox(height: 50),

                // List added exercises
                if (_sessionExercises.isNotEmpty) ...[
                  Text('Exercises in Session:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _sessionExercises.length,
                    itemBuilder: (context, index) {
                      var sessionExercise = _sessionExercises[index];
                      return ListTile(
                        title: Text(sessionExercise.exerciseName!),
                        subtitle: Text(
                            'Duration: ${sessionExercise.duration}s, Reps: ${sessionExercise.repetitions}, Series: ${sessionExercise.series}, Pause Exercise: ${sessionExercise.exercisePauseTime}s, Pause série: ${sessionExercise.seriePauseTime}s'),
                      );
                    },
                  ),
                ],
                
                SizedBox(height: 50),
                
                // Submit the session
                ElevatedButton(
                  onPressed: _createSession,
                  child: Text('Create Session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
