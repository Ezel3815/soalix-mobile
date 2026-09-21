import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rich-text controller for the card editor.
///
/// The field shows PLAIN text with real formatting (bold, italic, underline,
/// strike, colour) — never HTML tags, hidden characters or tiny placeholder
/// glyphs. Formatting is kept per character; the HTML-like tags the rest of
/// the app understands (`<b>`, `<i>`, `<u>`, `<s>`, `<span style="color:#rrggbb">`)
/// only exist at the edges: [setTagged] reads them in when a card is opened,
/// [tagged] writes them out when it is saved.
class RichTextEditingController extends TextEditingController {
  RichTextEditingController();

  static const int bold = 1;
  static const int italic = 2;
  static const int underline = 4;
  static const int strike = 8;

  List<int> _flags = <int>[];
  List<int?> _colors = <int?>[];
  bool _loading = false;

  // ─────────────────────── keeping formatting in step with typing

  @override
  set value(TextEditingValue newValue) {
    if (!_loading && newValue.text != text) {
      _syncAttributes(text, newValue.text);
    }
    super.value = newValue;
  }

  /// Shifts / trims the per-character formatting after the text changed
  /// (typing, deleting, pasting, replacing).
  void _syncAttributes(String oldText, String newText) {
    if (_flags.length != oldText.length) {
      _flags = List<int>.filled(oldText.length, 0, growable: true);
      _colors = List<int?>.filled(oldText.length, null, growable: true);
    }
    final oldLen = oldText.length;
    final newLen = newText.length;

    var prefix = 0;
    final maxPrefix = math.min(oldLen, newLen);
    while (prefix < maxPrefix &&
        oldText.codeUnitAt(prefix) == newText.codeUnitAt(prefix)) {
      prefix++;
    }
    var suffix = 0;
    final maxSuffix = math.min(oldLen, newLen) - prefix;
    while (suffix < maxSuffix &&
        oldText.codeUnitAt(oldLen - 1 - suffix) ==
            newText.codeUnitAt(newLen - 1 - suffix)) {
      suffix++;
    }

    final removed = oldLen - prefix - suffix;
    final inserted = newLen - prefix - suffix;

    if (removed > 0) {
      _flags.removeRange(prefix, prefix + removed);
      _colors.removeRange(prefix, prefix + removed);
    }
    if (inserted > 0) {
      // Text typed strictly inside a formatted run keeps that formatting;
      // text typed at its edges (or elsewhere) is plain.
      var f = 0;
      int? c;
      if (prefix > 0 &&
          prefix < _flags.length &&
          _flags[prefix - 1] == _flags[prefix] &&
          _colors[prefix - 1] == _colors[prefix]) {
        f = _flags[prefix];
        c = _colors[prefix];
      }
      _flags.insertAll(prefix, List<int>.filled(inserted, f));
      _colors.insertAll(prefix, List<int?>.filled(inserted, c));
    }
  }

  // ─────────────────────── what the field shows

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final base = style ?? const TextStyle();
    final t = text;
    if (t.isEmpty || _flags.length != t.length) {
      return TextSpan(style: base, text: t);
    }
    final spans = <InlineSpan>[];
    var start = 0;
    for (var i = 1; i <= t.length; i++) {
      if (i == t.length ||
          _flags[i] != _flags[start] ||
          _colors[i] != _colors[start]) {
        spans.add(TextSpan(
          text: t.substring(start, i),
          style: _styleFor(base, _flags[start], _colors[start]),
        ));
        start = i;
      }
    }
    return TextSpan(style: base, children: spans);
  }

  TextStyle _styleFor(TextStyle base, int flags, int? color) {
    final decorations = <TextDecoration>[
      if (flags & underline != 0) TextDecoration.underline,
      if (flags & strike != 0) TextDecoration.lineThrough,
    ];
    return base.copyWith(
      fontWeight: flags & bold != 0 ? FontWeight.w800 : null,
      fontStyle: flags & italic != 0 ? FontStyle.italic : null,
      color: color != null ? Color(color) : null,
      decoration:
          decorations.isEmpty ? null : TextDecoration.combine(decorations),
    );
  }

  // ─────────────────────── applying formatting to the selection

  bool get hasSelection => selection.isValid && selection.start != selection.end;

  int get _selStart => math.min(selection.start, selection.end);
  int get _selEnd => math.max(selection.start, selection.end);

  bool get _attributesReady => _flags.length == text.length;

  /// Toggles bold / italic / underline / strike on the selected text: if all
  /// of it already has the style it is removed, otherwise it is added.
  /// Returns false when nothing is selected.
  bool toggleFlag(int flag) {
    if (!hasSelection || !_attributesReady) return false;
    final s = _selStart.clamp(0, text.length).toInt();
    final e = _selEnd.clamp(0, text.length).toInt();
    var all = true;
    for (var i = s; i < e; i++) {
      if (_flags[i] & flag == 0) {
        all = false;
        break;
      }
    }
    for (var i = s; i < e; i++) {
      _flags[i] = all ? (_flags[i] & ~flag) : (_flags[i] | flag);
    }
    notifyListeners();
    return true;
  }

  /// Colours the selected text ([color] null clears the colour).
  bool setColor(Color? color) {
    if (!hasSelection || !_attributesReady) return false;
    final s = _selStart.clamp(0, text.length).toInt();
    final e = _selEnd.clamp(0, text.length).toInt();
    final argb = color == null ? null : (0xFF000000 | (color.value & 0x00FFFFFF));
    for (var i = s; i < e; i++) {
      _colors[i] = argb;
    }
    notifyListeners();
    return true;
  }

  // ─────────────────────── saving: formatting -> tags

  /// The text with formatting written as HTML-like tags (what gets saved).
  String get tagged {
    final t = text;
    if (t.isEmpty) return '';
    if (!_attributesReady) return _escape(t);
    final out = StringBuffer();
    var i = 0;
    while (i < t.length) {
      var j = i + 1;
      while (j < t.length && _flags[j] == _flags[i] && _colors[j] == _colors[i]) {
        j++;
      }
      out.write(_wrap(_escape(t.substring(i, j)), _flags[i], _colors[i]));
      i = j;
    }
    return out.toString();
  }

  String _wrap(String s, int flags, int? color) {
    var open = '';
    var close = '';
    if (color != null) {
      final hex = (color & 0x00FFFFFF).toRadixString(16).padLeft(6, '0');
      open += '<span style="color: #$hex;">';
      close = '</span>$close';
    }
    if (flags & bold != 0) {
      open += '<b>';
      close = '</b>$close';
    }
    if (flags & italic != 0) {
      open += '<i>';
      close = '</i>$close';
    }
    if (flags & underline != 0) {
      open += '<u>';
      close = '</u>$close';
    }
    if (flags & strike != 0) {
      open += '<s>';
      close = '</s>$close';
    }
    return '$open$s$close';
  }

  static String _escape(String s) =>
      s.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

  static String _unescape(String s) => s
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&');

  // ─────────────────────── opening a card: tags -> formatting

  static final RegExp _tagPattern =
      RegExp(r'<\s*(/?)\s*([a-zA-Z][a-zA-Z0-9]*)\b([^>]*)>');
  static final RegExp _colorPattern = RegExp(r'color:\s*#([0-9a-fA-F]{6})');

  /// Loads saved text: reads the tags into real formatting (unknown tags are
  /// dropped, their text is kept).
  void setTagged(String tagged) {
    final plain = StringBuffer();
    final flags = <int>[];
    final colors = <int?>[];
    var b = 0, i = 0, u = 0, s = 0;
    final colorStack = <int>[];
    final spanHadColor = <bool>[];

    void addText(String raw) {
      final text = _unescape(raw);
      final f = (b > 0 ? bold : 0) |
          (i > 0 ? italic : 0) |
          (u > 0 ? underline : 0) |
          (s > 0 ? strike : 0);
      final c = colorStack.isEmpty ? null : colorStack.last;
      for (final unit in text.codeUnits) {
        plain.writeCharCode(unit);
        flags.add(f);
        colors.add(c);
      }
    }

    var last = 0;
    for (final m in _tagPattern.allMatches(tagged)) {
      addText(tagged.substring(last, m.start));
      last = m.end;
      final closing = m.group(1) == '/';
      final name = (m.group(2) ?? '').toLowerCase();
      switch (name) {
        case 'b':
        case 'strong':
          b = math.max(0, b + (closing ? -1 : 1));
        case 'i':
        case 'em':
          i = math.max(0, i + (closing ? -1 : 1));
        case 'u':
          u = math.max(0, u + (closing ? -1 : 1));
        case 's':
        case 'strike':
        case 'del':
          s = math.max(0, s + (closing ? -1 : 1));
        case 'br':
          if (!closing) addText('\n');
        case 'span':
          if (closing) {
            if (spanHadColor.isNotEmpty && spanHadColor.removeLast()) {
              colorStack.removeLast();
            }
          } else {
            final cm = _colorPattern.firstMatch(m.group(3) ?? '');
            if (cm != null) {
              colorStack.add(int.parse('FF${cm.group(1)}', radix: 16));
              spanHadColor.add(true);
            } else {
              spanHadColor.add(false);
            }
          }
        default:
          break; // unknown tag: ignore the tag, keep the text
      }
    }
    addText(tagged.substring(last));

    _loading = true;
    text = plain.toString();
    _flags = flags;
    _colors = colors;
    _loading = false;
    selection = TextSelection.collapsed(offset: text.length);
  }
}
