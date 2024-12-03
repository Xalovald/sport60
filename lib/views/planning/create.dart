import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/domain/planning_domain.dart';

class PlanningCreate extends StatefulWidget {
  final SessionDomain session;

  const PlanningCreate({required this.session, super.key});

  @override
  State<PlanningCreate> createState() => _PlanningCreateState();
}

class _PlanningCreateState extends State<PlanningCreate> {
  final PlanningService _planningService = PlanningService();
  final SessionExerciseService _sessionExerciseService =
      SessionExerciseService();
  List<SessionExerciseDomain> _sessionExercises = [];
  final _formKey = GlobalKey<FormState>();

  // Champs pour le formulaire
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadSessionExercises();
  }

  // Récupérer les exercices de la séance sélectionnée
  Future<void> _loadSessionExercises() async {
    List<SessionExerciseDomain> sessionExercises = await _sessionExerciseService
        .getSessionExercisesBySessionId(widget.session.id!);
    setState(() {
      _sessionExercises = sessionExercises;
    });
  }

  // Fonction pour soumettre le formulaire
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Créer un planning ici avec les champs _selectedDate et _selectedTime
      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      String time = _selectedTime!.format(context);

      final planning = PlanningDomain(
        sessionId: widget.session.id!,
        sessionName: widget.session.name,
        date: date,
        time: time,
      );
      int planningId = await _planningService.addPlanning(planning);
      if (planningId != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Planning créé avec succès !')),
        );
      }
    }
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

            const SizedBox(height: 20),
            const Text(
              "Créer un planning:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Sélection de la date
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Sélectionnez une date",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    },
                    validator: (value) {
                      if (_selectedDate == null) {
                        return "Veuillez sélectionner une date";
                      }
                      return null;
                    },
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                          : '',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sélection de l'heure
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Sélectionnez une heure",
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    validator: (value) {
                      if (_selectedTime == null) {
                        return "Veuillez sélectionner une heure";
                      }
                      return null;
                    },
                    controller: TextEditingController(
                      text: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : '',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bouton de soumission
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Créer le planning"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
