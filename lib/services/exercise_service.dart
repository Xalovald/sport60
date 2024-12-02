import '../persistance/exercise_persistance.dart';
import '../domain/exercise_domain.dart';

class ExerciseService {
  final _exercisePersistance = ExercisePersistance();

  Future<int> addExercise(ExerciseDomain exercise) async {
    return await _exercisePersistance.insertExercise(exercise);
  }

  Future<List<ExerciseDomain>> getExercise() async {
    return await _exercisePersistance.getExercises();
  }

  Future<ExerciseDomain> getExerciseById(int exerciseId) async {
    return await _exercisePersistance.getExerciseById(exerciseId);
  }

  Future<int> deleteExercise(int exerciseId) async {
    return await _exercisePersistance.deleteExercise(exerciseId);
  }

  Future<int> updateExercise(ExerciseDomain exercise) async {
    return await _exercisePersistance.updateExercise(exercise);
  }
}