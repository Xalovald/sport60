class SessionTypeDomain {
  final int? id;
  final String name;
  final String? description;

  SessionTypeDomain({
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

  factory SessionTypeDomain.fromMap(Map<String, dynamic> map) {
    return SessionTypeDomain(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }
}
