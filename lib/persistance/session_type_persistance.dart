import './database_connect.dart';
import '../domain/session_type_domain.dart';

class SessionTypePersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<List<SessionTypeDomain>> getSessionTypes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('session_type');
    return List.generate(maps.length, (i) {
      return SessionTypeDomain.fromMap(maps[i]);
    });
  }
}
