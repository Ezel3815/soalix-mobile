# Mozaik Expanded Subject Icon Assets

## Important
These assets were extracted from the approved Mozaik expanded subject-icon board.

**Do not replace these with Lucide, Material, Font Awesome, or generic emoji icons.**
The colored subject tiles are a major part of the Mozaik visual identity.

## Subject icon rules
- Keep the full rounded-square tile.
- Preserve the soft pastel background, subtle gradient, depth, and shadow.
- Preserve the Mozaik-inspired geometric glyph treatment.
- Subject icons should be visually richer and more colorful than utility icons.
- Use the same icon asset consistently for a subject everywhere in the app.
- Do not recolor individual subject icons arbitrarily.
- Maintain roughly 48–56px displayed size in cards and 64–80px in subject/deck headers.

## Naming
Subject assets are in `subjects/`.
UI controls are in `actions/`.
`manifest.json` contains the complete mapping.

## Suggested implementation
React / web:
```tsx
<img src={`/assets/mozaik/subjects/${subject.slug}.png`}
     alt={subject.name}
     className="subject-icon" />
```

React Native:
```tsx
<Image
  source={require(`./assets/mozaik/subjects/${subject.slug}.png`)}
  style={{ width: 56, height: 56 }}
/>
```

## Production note
The supplied PNGs are the exact visual crops from the approved board. If your app needs infinite scaling or SVG manipulation, use these as the visual source of truth for a vector redraw; do not substitute a different icon library.
