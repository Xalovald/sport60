import '../persistance/session_type_persistance.dart';
import '../domain/session_type_domain.dart';

class SessionTypeService {
  final _sessionTypePersistance = SessionTypePersistance();

  Future<List<SessionTypeDomain>> getSessionTypes() async {
    return await _sessionTypePersistance.getSessionTypes();
  }
}
