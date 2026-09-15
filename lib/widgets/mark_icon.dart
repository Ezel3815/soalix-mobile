import 'package:flutter/material.dart';

/// The MOZAIK brand mark — a four-petal pinwheel — recolored per subject
/// to double as each deck's icon in the Library grid. Drawn directly
/// with CustomPainter instead of a raster asset, so it's always crisp,
/// scales to any size, and never depends on exported PNG files (which
/// is what caused the broken/mismatched icon crops).
class MozaikMarkIcon extends StatelessWidget {
  final Color color;
  final double size;

  const MozaikMarkIcon({
    super.key,
    required this.color,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MozaikMarkPainter(color: color),
      ),
    );
  }
}

class _MozaikMarkPainter extends CustomPainter {
  final Color color;
  const _MozaikMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final petalSize = size.width * 0.56;
    final offset = size.width * 0.145;
    final radius = Radius.circular(petalSize * 0.32);

    // Two-tone petals for the same layered look as the logo mark.
    final lightColor = Color.lerp(color, Colors.white, 0.38)!;

    final positions = <Offset>[
      center + Offset(0, -offset), // top
      center + Offset(offset, 0), // right
      center + Offset(0, offset), // bottom
      center + Offset(-offset, 0), // left
    ];
    final colors = [lightColor, color, lightColor, color];

    for (var i = 0; i < 4; i++) {
      final paint = Paint()..color = colors[i];
      final rect = Rect.fromCenter(
        center: positions[i],
        width: petalSize,
        height: petalSize,
      );
      canvas.save();
      canvas.translate(positions[i].dx, positions[i].dy);
      canvas.rotate(0.785398163); // 45°
      canvas.translate(-positions[i].dx, -positions[i].dy);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _MozaikMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
