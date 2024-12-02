import 'package:flutter/material.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/views/session/in_progress.dart';

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
      appBar: AppBar(
        title: const Text('Planned'),
      ),
      body: _plannings.isEmpty
          ? const Center(child: Text("Aucun planning disponible."))
          : ListView.builder(
              itemCount: _plannings.length,
              itemBuilder: (context, index) {
                final planning = _plannings[index];
                return ListTile(
                  title: Text(
                      "Session: ${planning.sessionName} - ${planning.date} à ${planning.time}"),
                  subtitle: Text("ID Session: ${planning.sessionId}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigation vers la nouvelle page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InProgressSession(sessionId: planning.sessionId),
                        ),
                      );
                    },
                    child: const Text("Démarrer"),
                  ),
                );
              },
            ),
    );
  }
}
