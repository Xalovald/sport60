class ExerciseDomain {
  final int? id;
  int sessionId;
  final String name;
  final int repetitions;
  final int duration;

  ExerciseDomain({
    this.id,
    required this.sessionId,
    required this.name,
    required this.repetitions,
    required this.duration,
  });

  // Convertir un objet Exercise en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'name': name,
      'repetitions': repetitions,
      'duration': duration,
    };
  }

  // Convertir un Map en objet Exercise
  factory ExerciseDomain.fromMap(Map<String, dynamic> map) {
    return ExerciseDomain(
      id: map['id'],
      sessionId: map['session_id'],
      name: map['name'],
      repetitions: map['repetitions'],
      duration: map['duration'],
    );
  }
}
