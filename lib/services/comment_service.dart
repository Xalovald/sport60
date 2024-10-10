import '../persistance/comment_persistance.dart';
import '../domain/comment_domain.dart';

class CommentService {
  final _commentPersistance = CommentPersistance();

  Future<int> addComment(CommentDomain comment) async {
    return await _commentPersistance.insertComment(comment);
  }

  Future<List<CommentDomain>> getComment(int sessionId, int? exerciseId) async {
    return await _commentPersistance.getComments(sessionId, exerciseId: exerciseId);
  }

  Future<int> deleteComment(int commentId) async {
    return await _commentPersistance.deleteComment(commentId);
  }

  Future<int> updateComment(CommentDomain comment) async {
    return await _commentPersistance.updateComment(comment);
  }
}