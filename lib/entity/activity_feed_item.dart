class ActivityFeedItem {
  final int id;
  final String type;
  final String title;
  final DateTime createdAt;
  final int userId;
  final String userName;
  final String? userAvatar;

  ActivityFeedItem({
    required this.id,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.userAvatar,
  });

  factory ActivityFeedItem.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return ActivityFeedItem(
      id: json['id'],
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      userId: user['id'] ?? 0,
      userName: user['name'] ?? '',
      userAvatar: user['avatar_hair'],
    );
  }

  /// Human copy for the feed row, e.g. "unlocked 7-Day Streak" or
  /// "completed Cardiology Basics" — built from real event data only.
  String get verbPhrase {
    switch (type) {
      case 'achievement_unlocked':
        return 'unlocked $title';
      case 'chapter_completed':
        return 'completed $title';
      case 'level_up':
        return title.toLowerCase(); // "Reached Level 5"
      default:
        return title;
    }
  }
}
