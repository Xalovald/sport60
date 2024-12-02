class SessionExerciseDomain {
  final int? id;
  int sessionId;
  final int exerciseId;
  int? duration;
  int? repetitions;
  int series;
  int? exercisePauseTime;
  int seriePauseTime;
  final String? exerciseName;
  final String? exerciseDescription;

  SessionExerciseDomain({
    this.id,
    required this.sessionId,
    required this.exerciseId,
    //this.exercise,
    this.duration,
    this.repetitions,
    this.series = 1,
    this.exercisePauseTime,
    this.seriePauseTime = 0,
    this.exerciseName,
    this.exerciseDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'exercise_id': exerciseId,
      'duration': duration,
      'repetitions': repetitions,
      'series': series,
      'exercise_pause_time': exercisePauseTime,
      'serie_pause_time': seriePauseTime,
    };
  }

  factory SessionExerciseDomain.fromMap(Map<String, dynamic> map) {
    return SessionExerciseDomain(
      id: map['id'],
      sessionId: map['session_id'],
      exerciseId: map['exercise_id'],
      duration: map['duration'],
      repetitions: map['repetitions'],
      series: map['series'],
      exercisePauseTime: map['exercise_pause_time'],
      seriePauseTime: map['serie_pause_time'],
      exerciseName: map['exercise_name'],
      exerciseDescription: map['exercise_description'],
    );
  }
}
