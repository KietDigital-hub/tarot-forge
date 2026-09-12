import 'dart:typed_data';
import '../../../../core/constants/tarot_78_cards_data.dart';

/// Immutable model representing the tarot card currently in design.
class TarotCard {
  final String id;
  final String romanNumeral;
  final String name;
  final String subtitle;
  final String templateId;
  final String? assetImagePath;
  final Uint8List? customImageBytes;
  final String? customImageName;
  final TarotSuit suit;
  final String element;
  final int number;
  final String englishName;
  final bool isCustomized;

  const TarotCard({
    required this.id,
    required this.romanNumeral,
    required this.name,
    required this.subtitle,
    required this.templateId,
    this.assetImagePath,
    this.customImageBytes,
    this.customImageName,
    this.suit = TarotSuit.major,
    this.element = 'Khí',
    this.number = 0,
    this.englishName = '',
    this.isCustomized = false,
  });

  bool get hasCustomImage => customImageBytes != null;

  /// Instantiate a TarotCard from a 78-card definition.
  factory TarotCard.fromDefinition(
    TarotCardDefinition def, {
    String templateId = 'classic_arcana',
  }) {
    return TarotCard(
      id: def.id,
      romanNumeral: def.romanNumeral,
      name: def.name,
      subtitle: def.keywords,
      templateId: templateId,
      assetImagePath: def.defaultAssetPath,
      suit: def.suit,
      element: def.element,
      number: def.number,
      englishName: def.englishName,
      isCustomized: false,
    );
  }

  TarotCard copyWith({
    String? id,
    String? romanNumeral,
    String? name,
    String? subtitle,
    String? templateId,
    String? assetImagePath,
    Uint8List? customImageBytes,
    String? customImageName,
    TarotSuit? suit,
    String? element,
    int? number,
    String? englishName,
    bool? isCustomized,
    bool clearCustomImage = false,
  }) {
    return TarotCard(
      id: id ?? this.id,
      romanNumeral: romanNumeral ?? this.romanNumeral,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      templateId: templateId ?? this.templateId,
      assetImagePath: assetImagePath ?? this.assetImagePath,
      customImageBytes: clearCustomImage
          ? null
          : (customImageBytes ?? this.customImageBytes),
      customImageName: clearCustomImage
          ? null
          : (customImageName ?? this.customImageName),
      suit: suit ?? this.suit,
      element: element ?? this.element,
      number: number ?? this.number,
      englishName: englishName ?? this.englishName,
      isCustomized: isCustomized ??
          (this.isCustomized ||
              customImageBytes != null ||
              clearCustomImage ||
              name != null ||
              romanNumeral != null ||
              subtitle != null),
    );
  }
}
