import '../persistance/type_session_persistance.dart';
import '../domain/type_session_domain.dart';

class TypeSessionService {
  final _typeSessionPersistance = TypeSessionPersistance();

  Future<List<TypeSessionDomain>> getTypeSession() async {
    return await _typeSessionPersistance.getTypesSessions();
  }
}