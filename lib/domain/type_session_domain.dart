class TypeSessionDomain {
  final int? id;
  final String name;

  TypeSessionDomain({
    this.id,
    required this.name,
  });

  // Convertir un Map en objet TypeSession
  factory TypeSessionDomain.fromMap(Map<String, dynamic> map) {
    return TypeSessionDomain(
      id: map['id'],
      name: map['name'],
    );
  }
}
