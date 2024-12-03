import 'package:flutter/material.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/exercise_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/domain/session_type_domain.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/services/session_type_service.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/exercise_service.dart';
import 'package:sport60/views/planning/choose_session.dart';
import 'package:sport60/widgets/button.dart';

class CreateSession extends StatefulWidget {
  const CreateSession({super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseFormKey = GlobalKey<FormState>();

  String? _sessionName;
  int? _sessionTypeId = 1;
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
  final SessionExerciseService _sessionExerciseService =
      SessionExerciseService();
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
        sessionExercise.sessionId = sessionId; // Associer l'ID de la session
        await _sessionExerciseService.addSessionExercise(sessionExercise);
      }

      if (sessionId != 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChooseSession(),
          ),
        );
      }
    }
  }
  // Ajouter un exercice à la session
  void _addSessionExercise() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedExerciseId != null) {
        final exercise =
            await _exerciseService.getExerciseById(_selectedExerciseId!);

        setState(() {
          _sessionExercises.add(SessionExerciseDomain(
            sessionId:
                0, // Cette valeur sera mise à jour lors de la création de la session
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
                  decoration:
                      InputDecoration(labelText: 'Description de l\'exercice'),
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
                    id: DateTime.now()
                        .millisecondsSinceEpoch, // Génère un ID unique
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
      appBar: AppBar(
        title: const Text('Création de la séance'),
        backgroundColor: const Color.fromARGB(255, 194, 167, 240),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Entrer un nom",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.fitness_center),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner un nom';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _sessionName = value;
                  },
                ),
                const SizedBox(height: 20),
                // Session type
                FutureBuilder<List<SessionTypeDomain>>(
                  future: _sessionTypeService.getSessionTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Error loading session types');
                    }

                    final sessionTypes = snapshot.data!;
                    return DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "Sélectionner un type",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.category),
                      ),
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
                          return 'Veuillez sélectionner un type de séance';
                        }
                        return null;
                      },
                    );
                  },
                ),

                if(_sessionTypeId == 1)...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Total duration (s)",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _totalDuration = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId == 1 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner la durée';
                      }
                      return null;
                    },
                  ),
                ],
              
                const SizedBox(height: 70),

                CustomButton(
                  onClick: _showAddExerciseDialog,
                  heroTag: 'AddExercise',
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                    border: Border.all(color: Colors.deepPurple.shade800, width: 2),
                  ),
                  child: const Text(
                    "Ajouter un exercice",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Select exercise
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Sélectionner un exercice'",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.fitness_center),
                  ),
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

                if(_sessionTypeId == 2) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Durée (s)",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _exerciseDuration = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId == 2 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner la durée';
                      }
                      return null;
                    },
                  ),
                ],
                
                if(_sessionTypeId != 2) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Repetitions",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.repeat),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _exerciseRepetitions = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId != 2 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner le nombre de répétition';
                      }
                      return null;
                    },
                  ),
                ],

                if(_sessionTypeId != 1) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Series",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _exerciseSeries = int.tryParse(value) ?? 1;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId != 1 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner le nombre de série';
                      }
                      return null;
                    },
                  ),
                ],

                if(_sessionTypeId == 2) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Pause entre exercices",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _exercisePauseTime = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId == 2 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner le temps de pause entre les exercices';
                      }
                      return null;
                    },
                  ),
                ],
                if(_sessionTypeId != 1) ...[
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Pause entre séries",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _exerciseSeriePauseTime = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (_sessionTypeId != 1 && (value == null || value.isEmpty)) {
                        return 'Veuillez renseigner le temps de pause entre les séries';
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 20),
                
                CustomButton(
                  onClick: _addSessionExercise,
                  heroTag: 'AddExerciseToSession',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                    border: Border.all(color: Colors.deepPurple.shade800, width: 2),
                  ),
                  child: const Text(
                    "Ajouté l'exercice à la session",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                _sessionExercises.isEmpty
                  ? const Text("Aucun exercice sélectionné.",
                      style: TextStyle(color: Colors.grey))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _sessionExercises.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(_sessionExercises[index].exerciseName!),
                            subtitle: Text(
                              _sessionTypeId == 1 ? 
                                "Répétitions: ${_sessionExercises[index].repetitions}" 
                              : _sessionTypeId == 2 ?
                               "Durée: ${_sessionExercises[index].duration} sec, séries: ${_sessionExercises[index].series}, pause entre exercices: ${_sessionExercises[index].exercisePauseTime}, pause entre séries ${_sessionExercises[index].seriePauseTime}"
                              : 
                                "Répétitions: ${_sessionExercises[index].repetitions}, séries: ${_sessionExercises[index].series}, pause entre séries: ${_sessionExercises[index].seriePauseTime}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),

                const SizedBox(height: 50),

                CustomButton(
                  onClick: _createSession,
                  heroTag: 'CreateSession',
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
                    "Créer la séance",
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
      ),
    );
  }
}
