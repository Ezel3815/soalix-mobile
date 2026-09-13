class AnswerResult {
  final bool leveledUp;
  final int? newLevel;
  final bool streakSaved;
  final int? newStreak;
  final bool chapterCompleted;
  final String? chapterTitle;
  final List<String> newAchievements;

  AnswerResult({
    required this.leveledUp,
    this.newLevel,
    required this.streakSaved,
    this.newStreak,
    required this.chapterCompleted,
    this.chapterTitle,
    this.newAchievements = const [],
  });

  factory AnswerResult.fromJson(Map<String, dynamic> json) {
    return AnswerResult(
      leveledUp: json['leveledUp'] ?? false,
      newLevel: json['newLevel'],
      streakSaved: json['streakSaved'] ?? false,
      newStreak: json['newStreak'],
      chapterCompleted: json['chapterCompleted'] ?? false,
      chapterTitle: json['chapterTitle'],
      newAchievements: json['newAchievements'] != null
          ? List<String>.from(json['newAchievements'])
          : [],
    );
  }

  /// True if there's anything worth showing a celebration for.
  bool get hasCelebration =>
      leveledUp || streakSaved || newAchievements.isNotEmpty;
}
