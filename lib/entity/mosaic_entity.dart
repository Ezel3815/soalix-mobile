/// Mirrors the backend's GET /users/me/mosaic response.
/// See src/mosaic/mosaic.service.ts (backend, source of truth for this shape).
class MosaicPieceOwned {
  final int pieceId;
  final int slot;
  final String kind;
  final bool revealed;

  MosaicPieceOwned({
    required this.pieceId,
    required this.slot,
    required this.kind,
    required this.revealed,
  });

  factory MosaicPieceOwned.fromJson(Map<String, dynamic> j) => MosaicPieceOwned(
        pieceId: j['pieceId'] as int,
        slot: j['slot'] as int,
        kind: j['kind'] as String,
        revealed: j['revealed'] == true,
      );
}

class MosaicStep {
  final bool done;
  final int progress;
  final int target;
  MosaicStep({required this.done, required this.progress, required this.target});
  factory MosaicStep.fromJson(Map<String, dynamic> j) => MosaicStep(
        done: j['done'] == true,
        progress: (j['progress'] as num?)?.toInt() ?? 0,
        target: (j['target'] as num?)?.toInt() ?? 0,
      );
}

class MosaicToday {
  final int day;
  final int allowance;
  final int stepsDone;
  final MosaicStep study;
  final MosaicStep mastery;
  final MosaicStep challenge;

  MosaicToday({
    required this.day,
    required this.allowance,
    required this.stepsDone,
    required this.study,
    required this.mastery,
    required this.challenge,
  });

  factory MosaicToday.fromJson(Map<String, dynamic> j) => MosaicToday(
        day: (j['day'] as num).toInt(),
        allowance: (j['allowance'] as num).toInt(),
        stepsDone: (j['stepsDone'] as num).toInt(),
        study: MosaicStep.fromJson(j['steps']['study']),
        mastery: MosaicStep.fromJson(j['steps']['mastery']),
        challenge: MosaicStep.fromJson(j['steps']['challenge']),
      );
}

class MosaicChest {
  final String id;
  final int index;
  final int unlockDay;
  final int pieces;
  final bool reachedDay;
  final bool ready;
  final bool claimed;

  MosaicChest({
    required this.id,
    required this.index,
    required this.unlockDay,
    required this.pieces,
    required this.reachedDay,
    required this.ready,
    required this.claimed,
  });

  factory MosaicChest.fromJson(Map<String, dynamic> j) => MosaicChest(
        id: j['id'] as String,
        index: (j['index'] as num).toInt(),
        unlockDay: (j['unlockDay'] as num).toInt(),
        pieces: (j['pieces'] as num).toInt(),
        reachedDay: j['reachedDay'] == true,
        ready: j['ready'] == true,
        claimed: j['claimed'] == true,
      );
}

/// status: timezone_required | not_started | active | catch_up | completed
class MosaicState {
  final String status;
  final String artworkId;
  final int totalPieces;
  final int seasonDays;
  final int seasonDay;
  final int piecesEarned;
  final int piecesRemaining;
  final List<MosaicPieceOwned> pieces;
  final MosaicToday? today;
  final List<MosaicChest> chests;

  MosaicState({
    required this.status,
    required this.artworkId,
    required this.totalPieces,
    required this.seasonDays,
    required this.seasonDay,
    required this.piecesEarned,
    required this.piecesRemaining,
    required this.pieces,
    required this.today,
    required this.chests,
  });

  bool get completed => status == 'completed';

  factory MosaicState.fromJson(Map<String, dynamic> j) => MosaicState(
        status: j['status'] as String? ?? 'not_started',
        artworkId: j['artworkId'] as String? ?? '',
        totalPieces: (j['totalPieces'] as num?)?.toInt() ?? 100,
        seasonDays: (j['seasonDays'] as num?)?.toInt() ?? 30,
        seasonDay: (j['seasonDay'] as num?)?.toInt() ?? 0,
        piecesEarned: (j['piecesEarned'] as num?)?.toInt() ?? 0,
        piecesRemaining: (j['piecesRemaining'] as num?)?.toInt() ?? 100,
        pieces: ((j['pieces'] as List?) ?? [])
            .map((e) => MosaicPieceOwned.fromJson(e as Map<String, dynamic>))
            .toList(),
        today: j['today'] != null ? MosaicToday.fromJson(j['today']) : null,
        chests: ((j['chests'] as List?) ?? [])
            .map((e) => MosaicChest.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

/// One earned piece, as returned inline from answerCard() / claimQuestChest().
class MosaicAwardedPiece {
  final int pieceId;
  final int slot;
  final String kind;

  MosaicAwardedPiece({required this.pieceId, required this.slot, required this.kind});

  factory MosaicAwardedPiece.fromJson(Map<String, dynamic> j) => MosaicAwardedPiece(
        pieceId: (j['pieceId'] as num).toInt(),
        slot: (j['slot'] as num).toInt(),
        kind: j['kind'] as String,
      );
}

/// The `mosaic` field inline on AnswerResult.
class MosaicAward {
  final String status;
  final List<MosaicAwardedPiece> newPieces;
  final bool completed;

  MosaicAward({required this.status, required this.newPieces, required this.completed});

  static MosaicAward? tryParse(dynamic j) {
    if (j is! Map<String, dynamic>) return null;
    return MosaicAward(
      status: j['status'] as String? ?? 'active',
      newPieces: ((j['newPieces'] as List?) ?? [])
          .map((e) => MosaicAwardedPiece.fromJson(e as Map<String, dynamic>))
          .toList(),
      completed: j['completed'] == true,
    );
  }
}
