import '../persistance/planning_persistance.dart';
import '../domain/planning_domain.dart';

class PlanningService {
  final _planningPersistance = PlanningPersistance();

  Future<int> addPlanning(PlanningDomain planning) async {
    return await _planningPersistance.insertPlanning(planning);
  }

  Future<List<PlanningDomain>> getPlannings() async {
    return await _planningPersistance.getPlannings();
  }

  Future<int> deletePlanning(int planningId) async {
    return await _planningPersistance.deletePlanning(planningId);
  }

  Future<int> updatePlanning(PlanningDomain planning) async {
    return await _planningPersistance.updatePlanning(planning);
  }
}