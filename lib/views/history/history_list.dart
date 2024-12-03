import 'package:flutter/material.dart';
import 'package:sport60/domain/planning_domain.dart';
import 'package:sport60/services/planning_service.dart';
import 'package:sport60/views/dashboard/detail.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});
  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final PlanningService _planningService = PlanningService();
  List<PlanningDomain> _histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistories();
  }

  // Charger les plannings depuis la base de données
  Future<void> _loadHistories() async {
    List<PlanningDomain> histories = await _planningService.getHistories();
    setState(() {
      _histories = histories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _histories.isEmpty
          ? const Center(child: Text("Aucune séance disponible.", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
              itemCount: _histories.length,
              itemBuilder: (context, index) {
                final history = _histories[index];
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
                        history.sessionName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Réalisé le: ${history.dateRealized} à ${history.timeRealized}"),
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
                                  DetailDashboard(sessionId: history.sessionId),
                            ),
                          );
                        },
                        child: const Text("Voir", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
