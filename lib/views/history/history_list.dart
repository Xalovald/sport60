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
      appBar: AppBar(
        title: const Text('Planned'),
      ),
      body: _histories.isEmpty
          ? const Center(child: Text("Aucun planning disponible."))
          : ListView.builder(
              itemCount: _histories.length,
              itemBuilder: (context, index) {
                final history = _histories[index];
                return ListTile(
                  title: Text(
                      "Session: ${history.sessionName} - ${history.dateRealized} à ${history.timeRealized}"),
                  subtitle: Text("ID Session: ${history.sessionId}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigation vers la nouvelle page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailDashboard(sessionId: history.sessionId),
                        ),
                      );
                    },
                    child: const Text("Voir"),
                  ),
                );
              },
            ),
    );
  }
}
