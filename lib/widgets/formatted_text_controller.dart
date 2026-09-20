import 'package:flutter/material.dart';

/// A [TextEditingController] that hides the HTML-like formatting tags
/// (<b>, <i>, <u>, <s>, <span style="color:#..">) used by the card
/// editor and shows their effect (bold, italic, colour...) instead.
/// The underlying text — and what is saved — is unchanged.
class FormattedTextEditingController extends TextEditingController {
  FormattedTextEditingController({super.text});

  static final RegExp _tag = RegExp(r'<(/?)(b|i|u|s|span)([^>]*)>');
  static final RegExp _color = RegExp(r'color:\s*#([0-9a-fA-F]{6,8})');

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final base = style ?? const TextStyle();
    // Zero-ish size + transparent: keeps text offsets identical (so the
    // cursor and selection still work) while the tag itself is invisible.
    final hidden = base.copyWith(fontSize: 0.01, color: Colors.transparent);

    final spans = <InlineSpan>[];
    final stack = <TextStyle>[base];
    var last = 0;

    for (final m in _tag.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: stack.last));
      }
      spans.add(TextSpan(text: m.group(0), style: hidden));
      last = m.end;

      final closing = m.group(1) == '/';
      if (closing) {
        if (stack.length > 1) stack.removeLast();
        continue;
      }
      final current = stack.last;
      switch (m.group(2)) {
        case 'b':
          stack.add(current.copyWith(fontWeight: FontWeight.bold));
          break;
        case 'i':
          stack.add(current.copyWith(fontStyle: FontStyle.italic));
          break;
        case 'u':
          stack.add(current.copyWith(decoration: _decoration(current, TextDecoration.underline)));
          break;
        case 's':
          stack.add(current.copyWith(decoration: _decoration(current, TextDecoration.lineThrough)));
          break;
        default:
          final c = _color.firstMatch(m.group(3) ?? '');
          var color = current.color;
          if (c != null) {
            var hex = c.group(1)!;
            if (hex.length == 6) hex = 'FF$hex';
            color = Color(int.parse(hex, radix: 16));
          }
          stack.add(current.copyWith(color: color));
      }
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: stack.last));
    }
    return TextSpan(style: base, children: spans);
  }

  static TextDecoration _decoration(TextStyle s, TextDecoration add) =>
      TextDecoration.combine([if (s.decoration != null) s.decoration!, add]);
}
