import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/views/session/in_progress.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/theme.dart';

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

  bool _isDatePassed(String date) {
    try {
      final currentDate = DateTime.now();
      final planningDate = DateTime.parse(date);
      return planningDate.isBefore(currentDate);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
                      leading: Icon(
                        _isDatePassed(planning.date)
                          ? Icons.warning_amber_rounded
                          : Icons.event,
                        color: Colors.purple,
                        size: 40,
                      ),
                      title: Text(
                        planning.sessionName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                          backgroundColor: themeNotifier.customButtonColor,
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
