int _int(dynamic v, [int d = 0]) => v is num ? v.toInt() : d;
bool _bool(dynamic v) => v == true;
Map<String, dynamic> _map(dynamic v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

class QuestChest {
  final String id;
  final int xp;
  final int at; // monthly milestones only
  final bool reached;
  final bool claimed;

  QuestChest({
    required this.id,
    required this.xp,
    this.at = 0,
    required this.reached,
    required this.claimed,
  });

  bool get claimable => reached && !claimed;

  factory QuestChest.fromJson(dynamic j) {
    final m = _map(j);
    return QuestChest(
      id: '${m['id'] ?? ''}',
      xp: _int(m['xp']),
      at: _int(m['at']),
      reached: _bool(m['reached']),
      claimed: _bool(m['claimed']),
    );
  }
}

class QuestPerson {
  final int id;
  final String name;
  final String? photo;

  QuestPerson({required this.id, required this.name, this.photo});

  static QuestPerson? fromJson(dynamic j) {
    if (j is! Map) return null;
    final m = _map(j);
    return QuestPerson(
      id: _int(m['id']),
      name: '${m['name'] ?? ''}',
      photo: m['avatar_hair'] as String?,
    );
  }
}

class DailyQuest {
  final String id;
  final String tier; // bronze | silver | gold
  final int xp;
  final int progress;
  final int target;
  final bool completed;
  final bool claimed;

  DailyQuest({
    required this.id,
    required this.tier,
    required this.xp,
    required this.progress,
    required this.target,
    required this.completed,
    required this.claimed,
  });

  bool get claimable => completed && !claimed;

  factory DailyQuest.fromJson(dynamic j) {
    final m = _map(j);
    return DailyQuest(
      id: '${m['id'] ?? ''}',
      tier: '${m['tier'] ?? 'bronze'}',
      xp: _int(m['xp']),
      progress: _int(m['progress']),
      target: _int(m['target'], 1) == 0 ? 1 : _int(m['target'], 1),
      completed: _bool(m['completed']),
      claimed: _bool(m['claimed']),
    );
  }
}

class QuestsData {
  // monthly
  final int month;
  final int daysLeft;
  final int monthPoints;
  final int monthTarget;
  final List<QuestChest> monthChests;

  // friends
  final int friendsHoursLeft;
  final int friendsTarget;
  final int myCount;
  final int partnerCount;
  final QuestPerson? me;
  final QuestPerson? partner;
  final QuestChest friendsChest;

  // daily
  final int dailyHoursLeft;
  final List<DailyQuest> daily;

  QuestsData({
    required this.month,
    required this.daysLeft,
    required this.monthPoints,
    required this.monthTarget,
    required this.monthChests,
    required this.friendsHoursLeft,
    required this.friendsTarget,
    required this.myCount,
    required this.partnerCount,
    required this.me,
    required this.partner,
    required this.friendsChest,
    required this.dailyHoursLeft,
    required this.daily,
  });

  factory QuestsData.fromJson(dynamic json) {
    final root = _map(json);
    final mo = _map(root['monthly']);
    final fr = _map(root['friends']);
    final da = _map(root['daily']);
    return QuestsData(
      month: _int(mo['month'], 1),
      daysLeft: _int(mo['days_left'], 1),
      monthPoints: _int(mo['points']),
      monthTarget: _int(mo['target'], 100) == 0 ? 100 : _int(mo['target'], 100),
      monthChests: (mo['chests'] is List ? mo['chests'] as List : const [])
          .map(QuestChest.fromJson)
          .toList(),
      friendsHoursLeft: _int(fr['hours_left'], 1),
      friendsTarget: _int(fr['target'], 50) == 0 ? 50 : _int(fr['target'], 50),
      myCount: _int(fr['my_count']),
      partnerCount: _int(fr['partner_count']),
      me: QuestPerson.fromJson(fr['me']),
      partner: QuestPerson.fromJson(fr['partner']),
      friendsChest: QuestChest.fromJson(fr['chest']),
      dailyHoursLeft: _int(da['hours_left'], 1),
      daily: (da['quests'] is List ? da['quests'] as List : const [])
          .map(DailyQuest.fromJson)
          .toList(),
    );
  }
}
