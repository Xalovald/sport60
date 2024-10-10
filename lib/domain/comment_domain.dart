class CommentDomain {
  final int? id;
  final int sessionId;
  final int? exerciseId;
  final String comment;
  final bool isGlobal;

  CommentDomain({
    this.id,
    required this.sessionId,
    this.exerciseId,
    required this.comment,
    required this.isGlobal,
  });

  // Convertir un objet Comment en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'comment': comment,
      'is_global': isGlobal ? 1 : 0,
    };
  }

  // Convertir un Map en objet Comment
  factory CommentDomain.fromMap(Map<String, dynamic> map) {
    return CommentDomain(
      id: map['id'],
      sessionId: map['session_id'],
      exerciseId: map['exercise_id'],
      comment: map['comment'],
      isGlobal: map['is_global'] == 1,
    );
  }
}
