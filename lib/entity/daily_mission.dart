class DailyMission {
  final String id;
  final String title;
  final int progress;
  final int target;
  final bool completed;

  DailyMission({
    required this.id,
    required this.title,
    required this.progress,
    required this.target,
    required this.completed,
  });

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      progress: json['progress'] ?? 0,
      target: json['target'] ?? 1,
      completed: json['completed'] ?? false,
    );
  }
}
