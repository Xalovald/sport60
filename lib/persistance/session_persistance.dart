import './database_connect.dart';
import '../domain/session_domain.dart';

class SessionPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<int> insertSession(SessionDomain session) async {
    final db = await _dbHelper.database;
    return await db.insert('session', session.toMap());
  }

  Future<SessionDomain> getSessionById(int sessionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'session',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
    return SessionDomain.fromMap(maps.first);
  }

  Future<List<SessionDomain>> getSessions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('session');
    return List.generate(maps.length, (i) {
      return SessionDomain.fromMap(maps[i]);
    });
  }

  Future<int> deleteSession(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('session', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSession(SessionDomain session) async {
    final db = await _dbHelper.database;
    return await db.update(
      'session',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }
}
