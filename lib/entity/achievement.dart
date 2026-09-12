class Achievement {
  final String id;
  final String title;
  final String description;
  final bool unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlocked,
    this.unlockedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      unlocked: json['unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.tryParse(json['unlocked_at'])
          : null,
    );
  }
}
