class PlanningDomain {
  final int? id;
  final int sessionId;
  final String date;
  final String time;

  PlanningDomain({
    this.id,
    required this.sessionId,
    required this.date,
    required this.time,
  });

  // Convertir un objet Plannification en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'date': date,
      'time': time,
    };
  }

  // Convertir un Map en objet Plannification
  factory PlanningDomain.fromMap(Map<String, dynamic> map) {
    return PlanningDomain(
      id: map['id'],
      sessionId: map['session_id'],
      date: map['date'],
      time: map['time'],
    );
  }
}
