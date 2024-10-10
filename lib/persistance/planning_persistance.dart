import './database_connect.dart';
import '../domain/planning_domain.dart';

class PlanningPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<int> insertPlanning(PlanningDomain plannification) async {
    final db = await _dbHelper.database;
    return await db.insert('planning', plannification.toMap());
  }

  Future<List<PlanningDomain>> getPlanning() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('planning');
    return List.generate(maps.length, (i) {
      return PlanningDomain.fromMap(maps[i]);
    });
  }

  Future<int> deletePlanning(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('planning', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePlanning(PlanningDomain planning) async {
    final db = await _dbHelper.database;
    return await db.update(
      'planning',
      planning.toMap(),
      where: 'id = ?',
      whereArgs: [planning.id],
    );
  }
}
