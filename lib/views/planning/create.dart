import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/views/planning/planning_list.dart';
import 'package:sport60/widgets/button.dart'; 
import 'package:sport60/widgets/theme.dart';

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PlanningList(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plannification"),
        backgroundColor: themeNotifier.currentTheme.primaryColor,
        foregroundColor: themeNotifier.currentTheme.textTheme.headlineSmall?.color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Permet de défiler en cas de contenu long
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Détails de la session
              Text(
                "Nom: ${widget.session.name}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Durée: ${widget.session.totalDuration} secondes",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                "Exercices:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Liste des exercices
              _sessionExercises.isEmpty
                  ? const Text("Aucun exercice disponible.",
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
                              "Répétitions: ${_sessionExercises[index].repetitions}, Durée: ${_sessionExercises[index].duration} sec",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
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
                      decoration: InputDecoration(
                        labelText: "Sélectionnez une date",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeNotifier.currentTheme.colorScheme.secondary,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                          color: themeNotifier.currentTheme.iconTheme.color,
                        ),
                        labelStyle: TextStyle(
                          color: themeNotifier.currentTheme.textTheme.bodyMedium?.color,
                        ),
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
                      decoration: InputDecoration(
                        labelText: "Sélectionnez une heure",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeNotifier.currentTheme.colorScheme.secondary,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.access_time,
                          color: themeNotifier.currentTheme.iconTheme.color,
                        ),
                        labelStyle: TextStyle(
                          color: themeNotifier.currentTheme.textTheme.bodyMedium?.color,
                        ),
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
                    CustomButton(
                      onClick: _submitForm,
                      heroTag: 'CreatePlanning',
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [themeNotifier.customButtonColor, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.deepPurple.shade800, width: 2),
                      ),
                      child: const Text(
                        "Créer le planning",
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
            ],
          ),
        ),
      ),
    );
  }
}
