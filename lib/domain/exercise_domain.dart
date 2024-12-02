class ExerciseDomain {
  final int? id;
  final String name;
  final String? description;

  ExerciseDomain({
    this.id,
    required this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory ExerciseDomain.fromMap(Map<String, dynamic> map) {
    return ExerciseDomain(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
