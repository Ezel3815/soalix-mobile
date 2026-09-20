class FollowPerson {
  final int id;
  final String name;
  final String? username;
  final String? photo;
  final bool isMe;
  bool isFollowing;

  FollowPerson({
    required this.id,
    required this.name,
    this.username,
    this.photo,
    required this.isMe,
    required this.isFollowing,
  });

  factory FollowPerson.fromJson(dynamic j) {
    final m = j is Map ? Map<String, dynamic>.from(j) : <String, dynamic>{};
    return FollowPerson(
      id: m['id'] is num ? (m['id'] as num).toInt() : 0,
      name: '${m['name'] ?? ''}',
      username: m['username'] as String?,
      photo: m['avatar_hair'] as String?,
      isMe: m['is_me'] == true,
      isFollowing: m['is_following'] == true,
    );
  }
}
