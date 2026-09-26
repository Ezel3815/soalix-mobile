import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Loads the shipped pieces.json (source of truth from the artwork pack —
/// never regenerated or guessed) and exposes each piece's real placement.
class MosaicPieceGeometry {
  final int id;
  final double xNorm;
  final double yNorm;
  final int rotationDeg;
  final List<int> bbox; // [x, y, width, height] in canvas px
  final String assetPath;

  MosaicPieceGeometry({
    required this.id,
    required this.xNorm,
    required this.yNorm,
    required this.rotationDeg,
    required this.bbox,
    required this.assetPath,
  });
}

class MosaicArtworkGeometry {
  final String artworkId;
  final double canvasWidth;
  final double canvasHeight;
  final Map<int, MosaicPieceGeometry> pieces; // by piece id
  final String masterAssetPath;

  MosaicArtworkGeometry({
    required this.artworkId,
    required this.canvasWidth,
    required this.canvasHeight,
    required this.pieces,
    required this.masterAssetPath,
  });

  static const _base = 'lib/assests/mosaic/garden-by-the-sea';
  static MosaicArtworkGeometry? _cached;

  static Future<MosaicArtworkGeometry> load() async {
    if (_cached != null) return _cached!;
    final raw = await rootBundle.loadString('$_base/pieces.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final artwork = json['artwork'] as Map<String, dynamic>;
    final canvas = artwork['canvas'] as Map<String, dynamic>;
    final pieces = <int, MosaicPieceGeometry>{};
    for (final p in (json['pieces'] as List)) {
      final m = p as Map<String, dynamic>;
      final id = m['id'] as int;
      pieces[id] = MosaicPieceGeometry(
        id: id,
        xNorm: (m['x'] as num).toDouble(),
        yNorm: (m['y'] as num).toDouble(),
        rotationDeg: (m['rotation'] as num).toInt(),
        bbox: (m['bbox'] as List).map((e) => (e as num).toInt()).toList(),
        // pieces.json says 'pieces/png/piece-001.png'; assets are bundled flat
        // under pieces/, so keep only the filename.
        assetPath: '$_base/pieces/${(m['png'] as String).split('/').last}',
      );
    }
    _cached = MosaicArtworkGeometry(
      artworkId: artwork['artworkId'] as String,
      canvasWidth: (canvas['width'] as num).toDouble(),
      canvasHeight: (canvas['height'] as num).toDouble(),
      pieces: pieces,
      masterAssetPath: '$_base/master.png',
    );
    return _cached!;
  }
}
