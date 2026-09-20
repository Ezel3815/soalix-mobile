int _i(dynamic v, [int d = 0]) => v is num ? v.toInt() : d;
Map<String, dynamic> _m(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

String _ago(DateTime t) {
  final d = DateTime.now().difference(t);
  if (d.inMinutes < 1) return 'الآن';
  if (d.inMinutes < 60) return 'منذ ${d.inMinutes} دقيقة';
  if (d.inHours < 24) return 'منذ ${d.inHours} ساعة';
  if (d.inDays < 30) return 'منذ ${d.inDays} يوم';
  return 'منذ فترة';
}

class FeedPost {
  final int id;
  final String type;
  final String title;
  final DateTime createdAt;
  final bool mine;
  final int userId;
  final String userName;
  final String? userPhoto;
  int celebrations;
  int comments;
  bool celebrated;

  FeedPost({
    required this.id,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.mine,
    required this.userId,
    required this.userName,
    this.userPhoto,
    required this.celebrations,
    required this.comments,
    required this.celebrated,
  });

  factory FeedPost.fromJson(dynamic j) {
    final m = _m(j);
    final u = _m(m['user']);
    return FeedPost(
      id: _i(m['id']),
      type: '${m['type'] ?? ''}',
      title: '${m['title'] ?? ''}',
      createdAt: DateTime.tryParse('${m['created_at'] ?? ''}') ?? DateTime.now(),
      mine: m['mine'] == true,
      userId: _i(u['id']),
      userName: '${u['name'] ?? ''}',
      userPhoto: u['avatar_hair'] as String?,
      celebrations: _i(m['celebrations']),
      comments: _i(m['comments']),
      celebrated: m['celebrated'] == true,
    );
  }

  String get timeAgo => _ago(createdAt.toLocal());

  /// Arabic post text built from the real event data.
  String get message {
    switch (type) {
      case 'chapter_completed':
        return 'أنهى فصل «$title» 🎯';
      case 'achievement_unlocked':
        return 'فتح إنجاز «$title» 🏆';
      case 'level_up':
        final n = RegExp(r'\d+').firstMatch(title);
        return n != null ? 'وصل إلى المستوى ${n.group(0)} ⭐' : title;
      default:
        return title;
    }
  }
}

class FeedComment {
  final int id;
  final String text;
  final DateTime createdAt;
  final int userId;
  final String userName;
  final String? userPhoto;

  FeedComment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.userPhoto,
  });

  factory FeedComment.fromJson(dynamic j) {
    final m = _m(j);
    final u = _m(m['user']);
    return FeedComment(
      id: _i(m['id']),
      text: '${m['text'] ?? ''}',
      createdAt: DateTime.tryParse('${m['created_at'] ?? ''}') ?? DateTime.now(),
      userId: _i(u['id']),
      userName: '${u['name'] ?? ''}',
      userPhoto: u['avatar_hair'] as String?,
    );
  }

  String get timeAgo => _ago(createdAt.toLocal());
}
