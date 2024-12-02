import './database_connect.dart';
import '../domain/comment_domain.dart';

class CommentPersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

  Future<int> insertComment(CommentDomain comment) async {
    final db = await _dbHelper.database;
    return await db.insert('comment', comment.toMap());
  }

  Future<List<CommentDomain>> getComments(int sessionId, {int? exerciseId}) async {
    final db = await _dbHelper.database;
    List<Map<String, dynamic>> maps;
    if (exerciseId != null) {
      maps = await db.query('comment', where: 'session_id = ? AND exercise_id = ?', whereArgs: [sessionId, exerciseId]);
    } else {
      maps = await db.query('comment', where: 'session_id = ?', whereArgs: [sessionId]);
    }
    return List.generate(maps.length, (i) {
      return CommentDomain.fromMap(maps[i]);
    });
  }

  Future<int> deleteComment(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('comment', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateComment(CommentDomain comment) async {
    final db = await _dbHelper.database;
    return await db.update(
      'comment',
      comment.toMap(),
      where: 'id = ?',
      whereArgs: [comment.id],
    );
  }
}
