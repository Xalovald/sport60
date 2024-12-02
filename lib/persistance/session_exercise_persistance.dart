import 'package:sport60/domain/session_exercise_domain.dart';
import './database_connect.dart';

class SessionExercisePersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();
    Future<int> insertSessionExercise(SessionExerciseDomain sessionExercise) async {
    final db = await _dbHelper.database;
    return await db.insert('session_exercise', sessionExercise.toMap());
  }

  // Future<List<SessionExerciseDomain>> getSessionExercises() async {
  //   final db = await _dbHelper.database;
  //   final List<Map<String, dynamic>> maps = await db.query('session_exercise');
  //   return List.generate(maps.length, (i) {
  //     return SessionExerciseDomain.fromMap(maps[i]);
  //   });
  // }

  // Future<List<SessionExerciseDomain>> getSessionExercisesBySessionId(int sessionId) async {
  //   final db = await _dbHelper.database;
  //   final List<Map<String, dynamic>> maps = await db.query('session_exercise', where: 'session_id = ?', whereArgs: [sessionId]);
  //   return List.generate(maps.length, (i) {
  //     return SessionExerciseDomain.fromMap(maps[i]);
  //   });
  // }

  Future<List<SessionExerciseDomain>> getSessionExercisesBySessionId(int sessionId) async {
  final db = await _dbHelper.database;

  // Jointure entre session_exercise et exercise
  final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT session_exercise.*, exercise.name AS exercise_name, exercise.description AS exercise_description
    FROM session_exercise
    INNER JOIN exercise ON session_exercise.exercise_id = exercise.id
    WHERE session_exercise.session_id = ?
  ''', [sessionId]);

  // Génération des objets en incluant les données d'exercice
  return List.generate(maps.length, (i) {
    return SessionExerciseDomain(
      id: maps[i]['id'],
      sessionId: maps[i]['session_id'],
      exerciseId: maps[i]['exercise_id'],
      duration: maps[i]['duration'],
      repetitions: maps[i]['repetitions'],
      series: maps[i]['series'],
      exerciseName: maps[i]['exercise_name'],
      exerciseDescription: maps[i]['exercise_description'],
    );
  });
}

  Future<int> deleteSessionExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('session_exercise', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSessionExercise(SessionExerciseDomain sessionExercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'session_exercise',
      sessionExercise.toMap(),
      where: 'id = ?',
      whereArgs: [sessionExercise.id],
    );
  }
}
