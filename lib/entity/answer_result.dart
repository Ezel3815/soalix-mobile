import 'mosaic_entity.dart';

class AnswerResult {
  final bool leveledUp;
  final int? newLevel;
  final bool streakSaved;
  final int? newStreak;
  final bool chapterCompleted;
  final String? chapterTitle;
  final List<String> newAchievements;
  final MosaicAward? mosaic;

  AnswerResult({
    required this.leveledUp,
    this.newLevel,
    required this.streakSaved,
    this.newStreak,
    required this.chapterCompleted,
    this.chapterTitle,
    this.newAchievements = const [],
    this.mosaic,
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
      // Older server responses (or the timezone_required state) omit this —
      // absence must never be treated as "no piece earned" by mistake, so
      // callers check `mosaic?.newPieces` rather than assuming a value.
      mosaic: MosaicAward.tryParse(json['mosaic']),
    );
  }

  /// True if there's anything worth showing a celebration for.
  bool get hasCelebration =>
      leveledUp || streakSaved || newAchievements.isNotEmpty;
}
