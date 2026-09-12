class LeaderboardEntry {
  final int id;
  final String name;
  final String? username;
  final String? avatarHair;
  final int xp;
  final int level;
  final bool isMe;

  LeaderboardEntry({
    required this.id,
    required this.name,
    this.username,
    this.avatarHair,
    required this.xp,
    required this.level,
    required this.isMe,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'],
      avatarHair: json['avatar_hair'],
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      isMe: json['isMe'] ?? false,
    );
  }

  String? get avatarPhotoName => avatarHair;
}
