class PlanningDomain {
  final int? id;
  final int sessionId;
  final String sessionName;
  final String date;
  final String? time;
  String? dateRealized;
  String? timeRealized;

  PlanningDomain({
    this.id,
    required this.sessionId,
    required this.sessionName,
    required this.date,
    this.time,
    this.dateRealized,
    this.timeRealized,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'session_id': sessionId,
      'date': date,
      'time': time,
      'date_realized': dateRealized,
      'time_realized': timeRealized,
    };
  }

  factory PlanningDomain.fromMap(Map<String, dynamic> map) {
    return PlanningDomain(
      id: map['id'],
      sessionId: map['session_id'],
      sessionName: map['session_name'] ?? '',
      date: map['date'],
      time: map['time'],
      dateRealized: map['date_realized'],
      timeRealized: map['time_realized'],
    );
  }
}
