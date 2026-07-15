class Region {
  final String id;

  final String name;

  final int level;

  const Region({
    required this.id,
    required this.name,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }

  factory Region.fromJson(
    Map<String, dynamic> json,
  ) {
    return Region(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
    );
  }
}
