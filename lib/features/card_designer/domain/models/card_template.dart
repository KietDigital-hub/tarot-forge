import '../../../../core/widgets/ornate_tarot_frame.dart';

/// Position styling options for text elements.
enum TextPlacement {
  headerAndFooter, // Numeral at top, title banner at bottom
  floatingBadges,  // Semi-transparent ornate pills floating on art
  minimalCentered, // Thin minimalist layout
  bottomCombined,  // Numeral and title grouped at bottom
}

/// Definition of a Tarot card template.
class CardTemplate {
  final String id;
  final String name;
  final String description;
  final TarotFrameStyle frameStyle;
  final TextPlacement textPlacement;
  final bool isFullBleedImage;

  const CardTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.frameStyle,
    required this.textPlacement,
    this.isFullBleedImage = false,
  });

  static const List<CardTemplate> allTemplates = [
    CardTemplate(
      id: 'classic_arcana',
      name: 'Classic Arcana',
      description: 'Gothic filigree, ornate corner flourishes & banner title',
      frameStyle: TarotFrameStyle.classicArcana,
      textPlacement: TextPlacement.headerAndFooter,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'celestial_mystic',
      name: 'Celestial Mystic',
      description: 'Eight-pointed stars, crescent moons & astral symmetry',
      frameStyle: TarotFrameStyle.celestialMystic,
      textPlacement: TextPlacement.headerAndFooter,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'minimalist_alchemy',
      name: 'Minimalist Alchemy',
      description: 'Modern luxury fine-line brackets & understated elegance',
      frameStyle: TarotFrameStyle.minimalistAlchemy,
      textPlacement: TextPlacement.minimalCentered,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'full_bleed_art',
      name: 'Full-Bleed Art',
      description: 'Edge-to-edge artwork with gilded bevel & floating badge',
      frameStyle: TarotFrameStyle.fullBleedArt,
      textPlacement: TextPlacement.floatingBadges,
      isFullBleedImage: true,
    ),
  ];
}
