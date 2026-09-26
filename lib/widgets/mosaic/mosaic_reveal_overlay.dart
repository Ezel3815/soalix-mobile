import 'package:flutter/material.dart';
import 'dart:async';
import 'mosaic_geometry.dart';

/// Plays the "one more piece clicks into place" animation for a single real
/// earned piece, then completes. Uses only Flutter's built-in animation APIs
/// (no new dependency). Timings follow the brief's suggested phases:
/// entrance -> travel -> slow down -> snap -> settle/glow.
///
/// [artworkRect] is where the destination artwork is currently laid out on
/// screen (in global coordinates), so the piece travels to its true bbox
/// position rather than a placeholder square.
Future<void> showMosaicPieceReveal(
  BuildContext context, {
  required MosaicPieceGeometry piece,
  required Offset sourceCenter,
  required Rect artworkRect,
  required double canvasWidth,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final completer = Completer<void>();
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _MosaicPieceRevealHost(
      piece: piece,
      sourceCenter: sourceCenter,
      artworkRect: artworkRect,
      canvasWidth: canvasWidth,
      onDone: () {
        entry.remove();
        completer.complete();
      },
    ),
  );
  overlay.insert(entry);
  return completer.future;
}

class _MosaicPieceRevealHost extends StatefulWidget {
  final MosaicPieceGeometry piece;
  final Offset sourceCenter;
  final Rect artworkRect;
  final double canvasWidth;
  final VoidCallback onDone;

  const _MosaicPieceRevealHost({
    required this.piece,
    required this.sourceCenter,
    required this.artworkRect,
    required this.canvasWidth,
    required this.onDone,
  });

  @override
  State<_MosaicPieceRevealHost> createState() => _MosaicPieceRevealHostState();
}

class _MosaicPieceRevealHostState extends State<_MosaicPieceRevealHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _c.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.piece;
    final scale = widget.artworkRect.width / widget.canvasWidth;
    final dest = Rect.fromLTWH(
      widget.artworkRect.left + p.bbox[0] * scale,
      widget.artworkRect.top + p.bbox[1] * scale,
      p.bbox[2] * scale,
      p.bbox[3] * scale,
    );
    final start = Rect.fromCenter(
      center: widget.sourceCenter,
      width: dest.width * 0.6,
      height: dest.height * 0.6,
    );

    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        final entrance = Curves.easeOut.transform((t / 0.18).clamp(0.0, 1.0));
        final travel = Curves.easeInOutCubic.transform(((t - 0.18) / 0.55).clamp(0.0, 1.0));
        final settle = ((t - 0.82) / 0.18).clamp(0.0, 1.0);

        final rect = Rect.lerp(start, dest, travel)!;
        final rotation = (1 - travel) * (p.rotationDeg * 3) * 3.14159 / 180;
        final glow = settle > 0 ? (1 - settle) : 0.0;

        return Positioned.fromRect(
          rect: rect,
          child: IgnorePointer(
            child: Opacity(
              opacity: entrance,
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: 0.85 + 0.15 * entrance,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: glow > 0
                          ? [
                              BoxShadow(
                                color: const Color(0xFFD8B65A).withOpacity(0.55 * glow),
                                blurRadius: 16 * glow,
                                spreadRadius: 2 * glow,
                              ),
                            ]
                          : null,
                    ),
                    child: Image.asset(p.assetPath, fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
