import 'package:sport60/domain/exercise_domain.dart';

import './database_connect.dart';

class ExercisePersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();

    Future<int> insertExercise(ExerciseDomain exercise) async {
    final db = await _dbHelper.database;
    return await db.insert('exercises', exercise.toMap());
  }

  Future<List<ExerciseDomain>> getExercises() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('exercises');
    return List.generate(maps.length, (i) {
      return ExerciseDomain.fromMap(maps[i]);
    });
  }

  Future<List<ExerciseDomain>> getExercisesBySessionId(int sessionId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('exercises', where: 'session_id = ?', whereArgs: [sessionId]);
    return List.generate(maps.length, (i) {
      return ExerciseDomain.fromMap(maps[i]);
    });
  }

  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('exercises', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(ExerciseDomain exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'exercises',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }
}
