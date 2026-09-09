/// Major Arcana presets with archetypal names, Roman numerals, and default keywords.
class TarotPreset {
  final String romanNumeral;
  final String name;
  final String keywords;
  final String assetImagePath;

  const TarotPreset({
    required this.romanNumeral,
    required this.name,
    required this.keywords,
    required this.assetImagePath,
  });
}

class TarotDeckData {
  TarotDeckData._();

  static const List<TarotPreset> samplePresets = [
    TarotPreset(
      romanNumeral: 'XVII',
      name: 'THE STAR',
      keywords: 'Hope • Inspiration • Serenity',
      assetImagePath: 'assets/images/the_star.jpg',
    ),
    TarotPreset(
      romanNumeral: 'I',
      name: 'THE MAGICIAN',
      keywords: 'Manifestation • Willpower • Creation',
      assetImagePath: 'assets/images/the_magician.jpg',
    ),
    TarotPreset(
      romanNumeral: 'XVIII',
      name: 'THE MOON',
      keywords: 'Illusion • Intuition • Subconscious',
      assetImagePath: 'assets/images/the_moon.jpg',
    ),
  ];
}
