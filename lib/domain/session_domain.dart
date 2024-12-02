class SessionDomain {
  final int? id;
  final String name;
  final int totalDuration;
  final int? pauseDuration;
  final int sessionTypeId;

  SessionDomain({
    this.id,
    required this.name,
    required this.totalDuration,
    this.pauseDuration,
    required this.sessionTypeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_duration': totalDuration,
      'pause_duration': pauseDuration,
      'session_type_id': sessionTypeId,
    };
  }

  factory SessionDomain.fromMap(Map<String, dynamic> map) {
    return SessionDomain(
      id: map['id'],
      name: map['name'],
      totalDuration: map['total_duration'],
      pauseDuration: map['pause_duration'],
      sessionTypeId: map['session_type_id'],
    );
  }
}
