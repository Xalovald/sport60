import '../persistance/session_persistance.dart';
import '../domain/session_domain.dart';

class SessionService {
  final _sessionPersistance = SessionPersistance();

  Future<int> addSession(SessionDomain session) async {
    return await _sessionPersistance.insertSession(session);
  }

  Future<List<SessionDomain>> getSession() async {
    return await _sessionPersistance.getSessions();
  }

  Future<int> deleteSession(int sessionId) async {
    return await _sessionPersistance.deleteSession(sessionId);
  }

  Future<int> updateSession(SessionDomain session) async {
    return await _sessionPersistance.updateSession(session);
  }
}