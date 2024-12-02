import 'package:sport60/domain/exercise_domain.dart';
import './database_connect.dart';

class ExercisePersistance {
  final DatabaseConnect _dbHelper = DatabaseConnect();
    Future<int> insertExercise(ExerciseDomain exercise) async {
    final db = await _dbHelper.database;
    return await db.insert('exercise', exercise.toMap());
  }

  Future<List<ExerciseDomain>> getExercises() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('exercise');
    return List.generate(maps.length, (i) {
      return ExerciseDomain.fromMap(maps[i]);
    });
  }

  Future<ExerciseDomain> getExerciseById(int exerciseId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'exercise',
      where: 'id = ?',
      whereArgs: [exerciseId],
    );
    return ExerciseDomain.fromMap(maps.first);
  }

  Future<int> deleteExercise(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('exercise', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateExercise(ExerciseDomain exercise) async {
    final db = await _dbHelper.database;
    return await db.update(
      'exercise',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }
}
