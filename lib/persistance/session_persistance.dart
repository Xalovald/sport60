import './database_connect.dart';
import '../domain/session_domain.dart';

class SessionPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<int> insertSession(SessionDomain session) async {
    final db = await _dbHelper.database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<SessionDomain>> getSessions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('sessions');
    return List.generate(maps.length, (i) {
      return SessionDomain.fromMap(maps[i]);
    });
  }

  Future<int> deleteSession(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSession(SessionDomain session) async {
    final db = await _dbHelper.database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }
}
