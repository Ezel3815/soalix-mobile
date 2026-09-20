import 'package:flutter/material.dart';

/// Centers content and caps its width on tablets so pages stop stretching
/// edge to edge and reading columns / cards stop over-growing. On phones
/// (width < 600) this is a no-op — content fills the screen exactly as
/// before.
class TabletBounded extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const TabletBounded({super.key, required this.child, this.maxWidth = 680});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// True once the screen is wide enough to be considered a tablet.
bool isTabletWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= 600;
