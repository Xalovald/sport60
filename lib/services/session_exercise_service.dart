import '../persistance/session_exercise_persistance.dart';
import '../domain/session_exercise_domain.dart';

class SessionExerciseService {
  final _sessionExercisePersistance = SessionExercisePersistance();

  Future<int> addSessionExercise(SessionExerciseDomain sessionExercise) async {
    return await _sessionExercisePersistance.insertSessionExercise(sessionExercise);
  }

  // Future<List<SessionExerciseDomain>> getExercise() async {
  //   return await _sessionExercisePersistance.getSessionExercises();
  // }

  Future<List<SessionExerciseDomain>> getSessionExercisesBySessionId(int sessionId) async {
    return await _sessionExercisePersistance.getSessionExercisesBySessionId(sessionId);
  }

  Future<int> deleteSessionExercise(int sessionExerciseId) async {
    return await _sessionExercisePersistance.deleteSessionExercise(sessionExerciseId);
  }

  Future<int> updateSessionExercise(SessionExerciseDomain sessionExercise) async {
    return await _sessionExercisePersistance.updateSessionExercise(sessionExercise);
  }
}