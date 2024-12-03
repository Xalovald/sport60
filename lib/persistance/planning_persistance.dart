import './database_connect.dart';
import '../domain/planning_domain.dart';

class PlanningPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<int> insertPlanning(PlanningDomain plannification) async {
    final db = await _dbHelper.database;
    return await db.insert('planning', plannification.toMap());
  }

  Future<PlanningDomain> getPlanningBySessionId(int sessionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'planning',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    return PlanningDomain.fromMap(maps.first);
  }

  Future<List<PlanningDomain>> getPlannings() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT planning.*, session.name as session_name
      FROM planning
      INNER JOIN session ON planning.session_id = session.id
      WHERE planning.date_realized IS NULL
    ''');
    return List.generate(maps.length, (i) {
      return PlanningDomain.fromMap(maps[i]);
    });
  }

  Future<List<PlanningDomain>> getHistories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT planning.*, session.name as session_name
      FROM planning
      INNER JOIN session ON planning.session_id = session.id
      WHERE planning.date_realized IS NOT NULL
    ''');
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
