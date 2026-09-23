import 'package:flutter/widgets.dart' show IconData;
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// Everything except PhosphorIcons passes straight through to the real
// replacement package (PhosphorIcon widget, PhosphorIconsStyle enum,
// PhosphorIconsThin/Light/Regular/Bold/Fill classes, etc.).
export 'package:phosphoricons_flutter/phosphoricons_flutter.dart'
    hide PhosphorIcons;

// The app calls icons the old way: PhosphorIcons.house(PhosphorIconsStyle.bold).
// This class re-creates that exact pattern on top of the new package, which
// only offers icons the other way (PhosphorIconsBold.house). Add a line here
// for each icon name your app uses this way. If a new "getter isn't defined"
// error shows up after this, it just means one more icon name needs adding
// below — same shape as the ones already here.
class _Icon {
  final IconData thin, light, regular, bold, fill;
  const _Icon({
    required this.thin,
    required this.light,
    required this.regular,
    required this.bold,
    required this.fill,
  });
  // duotone isn't a plain icon glyph in the new package, so it falls back
  // to the regular style — same outline, just without the two-tone look.
  IconData call([PhosphorIconsStyle style = PhosphorIconsStyle.regular]) {
    switch (style) {
      case PhosphorIconsStyle.thin:
        return thin;
      case PhosphorIconsStyle.light:
        return light;
      case PhosphorIconsStyle.bold:
        return bold;
      case PhosphorIconsStyle.fill:
        return fill;
      case PhosphorIconsStyle.regular:
      case PhosphorIconsStyle.duotone:
        return regular;
    }
  }
}

class PhosphorIcons {
  static const pencilSimpleLine = _Icon(
    thin: PhosphorIconsThin.pencilSimpleLine,
    light: PhosphorIconsLight.pencilSimpleLine,
    regular: PhosphorIconsRegular.pencilSimpleLine,
    bold: PhosphorIconsBold.pencilSimpleLine,
    fill: PhosphorIconsFill.pencilSimpleLine,
  );
  static const magnifyingGlass = _Icon(
    thin: PhosphorIconsThin.magnifyingGlass,
    light: PhosphorIconsLight.magnifyingGlass,
    regular: PhosphorIconsRegular.magnifyingGlass,
    bold: PhosphorIconsBold.magnifyingGlass,
    fill: PhosphorIconsFill.magnifyingGlass,
  );
  static const gearSix = _Icon(
    thin: PhosphorIconsThin.gearSix,
    light: PhosphorIconsLight.gearSix,
    regular: PhosphorIconsRegular.gearSix,
    bold: PhosphorIconsBold.gearSix,
    fill: PhosphorIconsFill.gearSix,
  );
  static const userCircle = _Icon(
    thin: PhosphorIconsThin.userCircle,
    light: PhosphorIconsLight.userCircle,
    regular: PhosphorIconsRegular.userCircle,
    bold: PhosphorIconsBold.userCircle,
    fill: PhosphorIconsFill.userCircle,
  );
  static const camera = _Icon(
    thin: PhosphorIconsThin.camera,
    light: PhosphorIconsLight.camera,
    regular: PhosphorIconsRegular.camera,
    bold: PhosphorIconsBold.camera,
    fill: PhosphorIconsFill.camera,
  );
  static const flame = _Icon(
    thin: PhosphorIconsThin.flame,
    light: PhosphorIconsLight.flame,
    regular: PhosphorIconsRegular.flame,
    bold: PhosphorIconsBold.flame,
    fill: PhosphorIconsFill.flame,
  );
  static const usersThree = _Icon(
    thin: PhosphorIconsThin.usersThree,
    light: PhosphorIconsLight.usersThree,
    regular: PhosphorIconsRegular.usersThree,
    bold: PhosphorIconsBold.usersThree,
    fill: PhosphorIconsFill.usersThree,
  );
  static const shareNetwork = _Icon(
    thin: PhosphorIconsThin.shareNetwork,
    light: PhosphorIconsLight.shareNetwork,
    regular: PhosphorIconsRegular.shareNetwork,
    bold: PhosphorIconsBold.shareNetwork,
    fill: PhosphorIconsFill.shareNetwork,
  );
  static const house = _Icon(
    thin: PhosphorIconsThin.house,
    light: PhosphorIconsLight.house,
    regular: PhosphorIconsRegular.house,
    bold: PhosphorIconsBold.house,
    fill: PhosphorIconsFill.house,
  );
  static const cloudArrowUp = _Icon(
    thin: PhosphorIconsThin.cloudArrowUp,
    light: PhosphorIconsLight.cloudArrowUp,
    regular: PhosphorIconsRegular.cloudArrowUp,
    bold: PhosphorIconsBold.cloudArrowUp,
    fill: PhosphorIconsFill.cloudArrowUp,
  );
  static const keyboard = _Icon(
    thin: PhosphorIconsThin.keyboard,
    light: PhosphorIconsLight.keyboard,
    regular: PhosphorIconsRegular.keyboard,
    bold: PhosphorIconsBold.keyboard,
    fill: PhosphorIconsFill.keyboard,
  );
  static const bell = _Icon(
    thin: PhosphorIconsThin.bell,
    light: PhosphorIconsLight.bell,
    regular: PhosphorIconsRegular.bell,
    bold: PhosphorIconsBold.bell,
    fill: PhosphorIconsFill.bell,
  );
  static const thumbsUp = _Icon(
    thin: PhosphorIconsThin.thumbsUp,
    light: PhosphorIconsLight.thumbsUp,
    regular: PhosphorIconsRegular.thumbsUp,
    bold: PhosphorIconsBold.thumbsUp,
    fill: PhosphorIconsFill.thumbsUp,
  );
  static const question = _Icon(
    thin: PhosphorIconsThin.question,
    light: PhosphorIconsLight.question,
    regular: PhosphorIconsRegular.question,
    bold: PhosphorIconsBold.question,
    fill: PhosphorIconsFill.question,
  );
  static const signOut = _Icon(
    thin: PhosphorIconsThin.signOut,
    light: PhosphorIconsLight.signOut,
    regular: PhosphorIconsRegular.signOut,
    bold: PhosphorIconsBold.signOut,
    fill: PhosphorIconsFill.signOut,
  );
}
