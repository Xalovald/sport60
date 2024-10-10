import './database_connect.dart';
import '../domain/type_session_domain.dart';

class TypeSessionPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  // Récupérer tous les types de séances
  Future<List<TypeSessionDomain>> getTypesSessions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('types_sessions');
    return List.generate(maps.length, (i) {
      return TypeSessionDomain.fromMap(maps[i]);
    });
  }
}
