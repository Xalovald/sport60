class SessionDomain {
  final int? id;
  final String name;
  final int totalDuration;
  final int? pauseDuration;
  final int typeId;

  SessionDomain({
    this.id,
    required this.name,
    required this.totalDuration,
    this.pauseDuration,
    required this.typeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'total_duration': totalDuration,
      'pause_duration': pauseDuration,
      'type_id': typeId,
    };
  }

  factory SessionDomain.fromMap(Map<String, dynamic> map) {
    return SessionDomain(
      id: map['id'],
      name: map['name'],
      totalDuration: map['total_duration'],
      pauseDuration: map['pause_duration'],
      typeId: map['type_id'],
    );
  }
}
