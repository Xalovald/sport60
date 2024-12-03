import 'package:flutter/material.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/views/session/in_progress.dart';
import 'package:sport60/widgets/button.dart';

class PlanningList extends StatefulWidget {
  const PlanningList({super.key});
  @override
  State<PlanningList> createState() => _PlanningListState();
}

class _PlanningListState extends State<PlanningList> {
  final PlanningService _planningService = PlanningService();
  List<PlanningDomain> _plannings = [];

  @override
  void initState() {
    super.initState();
    _loadPlannings();
  }

  // Charger les plannings depuis la base de données
  Future<void> _loadPlannings() async {
    List<PlanningDomain> plannings = await _planningService.getPlannings();
    setState(() {
      _plannings = plannings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _plannings.isEmpty
          ? const Center(child: Text("Aucun planning disponible.", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: _plannings.length,
              itemBuilder: (context, index) {
                final planning = _plannings[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: const Icon(
                        Icons.event,
                        color: Colors.purple,
                        size: 40,
                      ),
                      title: Text(
                        planning.sessionName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${planning.date}"),
                          Text("Heure: ${planning.time}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 194, 167, 240),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Navigation vers la page d'inprogress
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InProgressSession(sessionId: planning.sessionId),
                            ),
                          );
                        },
                        child: const Text("Démarrer", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
