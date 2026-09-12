/// Maps a subject/deck title to one of the real Mozaik subject icon
/// assets (lib/assests/images/subjects/*.png) by keyword matching.
/// These are designed illustrations, not a generic icon font — per the
/// asset pack's own guidance, the same asset should be used consistently
/// for a given subject everywhere in the app, never recolored per-card.
///
/// Falls back to a generic "education" tile when nothing matches, so a
/// subject with an unrecognized name never renders blank.
String subjectIconAsset(String title) {
  final t = title.toLowerCase();

  // Ordered by specificity — more specific keywords are checked first
  // so e.g. "biochemistry" doesn't just match generic "chemistry" logic
  // in an unhelpful order.
  const mapping = <String, String>{
    // Medical / pre-med — mapped to the closest available real subject art
    'pharmacology': 'medicine',
    'pharma': 'medicine',
    'pathology': 'medicine',
    'radiology': 'medicine',
    'surgery': 'medicine',
    'clinical': 'medicine',
    'immunology': 'medicine',
    'microbiology': 'biology',
    'anatomy': 'biology',
    'physiology': 'biology',
    'biochemistry': 'chemistry',
    'genetics': 'genetics',
    'psychiatry': 'psychology',
    'psychology': 'psychology',
    'medicine': 'medicine',
    'medical': 'medicine',
    'health': 'health',

    // Core sciences
    'biology': 'biology',
    'chemistry': 'chemistry',
    'physics': 'physics',
    'science': 'science',

    // Languages
    'english': 'english',
    'arabic': 'arabic_language',
    'language': 'languages',

    // Math
    'mathematics': 'math',
    'math': 'math',

    // Other common subjects
    'business': 'business',
    'history': 'history',
    'geography': 'geography',
    'economics': 'economics',
    'literature': 'literature',
    'writing': 'writing',
    'general knowledge': 'general_knowledge',
    'technology': 'technology',
    'computer': 'computer-science',
    'coding': 'coding',
    'programming': 'coding',
    'engineering': 'engineering',
    'art': 'arts',
  };

  for (final entry in mapping.entries) {
    if (t.contains(entry.key)) {
      return 'lib/assests/images/subjects/${entry.value}.png';
    }
  }

  return 'lib/assests/images/subjects/education.png';
}
