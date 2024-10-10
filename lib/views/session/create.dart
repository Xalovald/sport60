import 'package:flutter/material.dart';
import 'package:sport60/services/exercise_service.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/domain/exercise_domain.dart';
import 'package:sport60/domain/session_domain.dart';

class CreateSession extends StatefulWidget {
  const CreateSession({super.key});

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  final SessionService _sessionService = SessionService();
  final ExerciseService _exerciseService = ExerciseService();

  List<ExerciseDomain> _exercises = [];
  List<ExerciseDomain> _addedExercises = []; // Liste des exercices ajoutés à la séance

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  ExerciseDomain? _selectedExercise;
  final TextEditingController _newExerciseNameController = TextEditingController();
  final TextEditingController _newExerciseRepsController = TextEditingController();
  final TextEditingController _newExerciseDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  // Récupérer la liste des exercices existants
  Future<void> _loadExercises() async {
    List<ExerciseDomain> exercises = await _exerciseService.getExercise(); 
    setState(() {
      _exercises = exercises;
    });
  }

  // Fonction pour créer une séance
  Future<void> _createSession() async {
    if (_formKey.currentState!.validate()) {
      SessionDomain newSession = SessionDomain(
        name: _nameController.text,
        totalDuration: int.parse(_durationController.text),
        typeId: 1, // Remplacez par l'ID de type souhaité
      );

      int sessionId = await _sessionService.addSession(newSession);
      
      // Ajouter les exercices associés à la séance
      for (var exercise in _addedExercises) {
        exercise.sessionId = sessionId;
        await _exerciseService.addExercise(exercise);
      }

      // Réinitialiser les contrôleurs
      _nameController.clear();
      _durationController.clear();
      _addedExercises.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Séance créée avec succès!")),
      );
    }
  }

  // Fonction pour ajouter un nouvel exercice
  void _addNewExercise() {
    if (_newExerciseNameController.text.isNotEmpty &&
        _newExerciseRepsController.text.isNotEmpty &&
        _newExerciseDurationController.text.isNotEmpty) {
      ExerciseDomain newExercise = ExerciseDomain(
        name: _newExerciseNameController.text,
        repetitions: int.parse(_newExerciseRepsController.text),
        duration: int.parse(_newExerciseDurationController.text),
        sessionId: 0, // ID de session à 0, car il sera assigné plus tard
      );

      //_exerciseService.addExercise(newExercise);
      setState(() {
        _addedExercises.add(newExercise);
      });

      // Réinitialiser les contrôleurs pour le nouvel exercice
      _newExerciseNameController.clear();
      _newExerciseRepsController.clear();
      _newExerciseDurationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer une séance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Champ pour le nom de la séance
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom de la séance"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de la séance';
                  }
                  return null;
                },
              ),
              // Champ pour la durée de la séance
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: "Durée (minutes)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la durée de la séance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Dropdown pour sélectionner un exercice existant
              // DropdownButton<ExerciseDomain>(
              //   hint: const Text("Sélectionner un exercice existant"),
              //   value: _selectedExercise,
              //   onChanged: (ExerciseDomain? newValue) {
              //     setState(() {
              //       _selectedExercise = newValue;
              //     });
              //   },
              //   items: _exercises.map<DropdownMenuItem<ExerciseDomain>>((ExerciseDomain exercise) {
              //     return DropdownMenuItem<ExerciseDomain>(
              //       value: exercise,
              //       child: Text(exercise.name),
              //     );
              //   }).toList(),
              // ),
              // const SizedBox(height: 10),
              // // Bouton pour ajouter l'exercice sélectionné à la séance
              // ElevatedButton(
              //   onPressed: () {
              //     if (_selectedExercise != null) {
              //       setState(() {
              //         _addedExercises.add(_selectedExercise!);
              //         _selectedExercise = null; // Réinitialiser la sélection
              //       });
              //     }
              //   },
              //   child: const Text("Ajouter cet exercice à la séance"),
              // ),
              // const SizedBox(height: 20),
              // Champs pour ajouter un nouvel exercice
              const Text("Ajouter un nouvel exercice :"),
              TextFormField(
                controller: _newExerciseNameController,
                decoration: const InputDecoration(labelText: "Nom de l'exercice"),
              ),
              TextFormField(
                controller: _newExerciseRepsController,
                decoration: const InputDecoration(labelText: "Répétitions"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _newExerciseDurationController,
                decoration: const InputDecoration(labelText: "Durée (minutes)"),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _addNewExercise,
                child: const Text("Ajouter le nouvel exercice"),
              ),
              const SizedBox(height: 20),
              // Liste des exercices ajoutés
              const Text("Exercices ajoutés :"),
              Expanded(
                child: ListView.builder(
                  itemCount: _addedExercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_addedExercises[index].name),
                      subtitle: Text(
                          "Répétitions: ${_addedExercises[index].repetitions}, Durée: ${_addedExercises[index].duration} minutes"),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Bouton pour créer la séance
              ElevatedButton(
                onPressed: _createSession,
                child: const Text("Créer la séance"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
