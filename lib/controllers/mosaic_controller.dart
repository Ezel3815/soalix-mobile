import 'package:get/get.dart';
import 'package:upgrade/controllers/api_controller.dart';
import 'package:upgrade/entity/mosaic_entity.dart';
import 'package:upgrade/widgets/mosaic/mosaic_geometry.dart';

/// Owns the mosaic's read model. State always comes from GET /users/me/mosaic
/// (the server ledger), never invented client-side — that's what keeps a
/// second device or a reinstalled app showing the same painting.
class MosaicController extends GetxController {
  final state = Rxn<MosaicState>();
  final geometry = Rxn<MosaicArtworkGeometry>();
  final loading = true.obs;

  /// Pieces earned but not yet animated in (queued by the result screen /
  /// chest claim so the flight animation can play once, then acked).
  final pendingReveal = <MosaicAwardedPiece>[].obs;

  Set<int> get ownedPieceIds =>
      state.value?.pieces.map((p) => p.pieceId).toSet() ?? <int>{};

  @override
  void onInit() {
    super.onInit();
    refresh();
    MosaicArtworkGeometry.load().then((g) => geometry.value = g);
  }

  Future<void> refresh() async {
    loading.value = true;
    state.value = await ApiController.getMosaic();
    loading.value = false;
  }

  /// Called after a study-session answer. Queues any newly-earned pieces for
  /// the flight animation and refreshes the ledger state underneath it.
  void handleAward(MosaicAward? award) {
    if (award == null || award.newPieces.isEmpty) return;
    pendingReveal.addAll(award.newPieces);
    refresh();
  }

  Future<void> claimChest(String id) async {
    final award = await ApiController.claimMosaicChest(id);
    handleAward(award);
    if (award == null) await refresh(); // chest status may still have changed
  }

  /// Called by the mosaic screen once a piece's flight animation finishes.
  void markRevealed(MosaicAwardedPiece piece) {
    pendingReveal.remove(piece);
    ApiController.ackMosaicReveal([piece.pieceId]);
  }
}
