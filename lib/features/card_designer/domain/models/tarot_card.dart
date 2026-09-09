import 'dart:typed_data';

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

  const TarotCard({
    required this.id,
    required this.romanNumeral,
    required this.name,
    required this.subtitle,
    required this.templateId,
    this.assetImagePath,
    this.customImageBytes,
    this.customImageName,
  });

  bool get hasCustomImage => customImageBytes != null;

  TarotCard copyWith({
    String? id,
    String? romanNumeral,
    String? name,
    String? subtitle,
    String? templateId,
    String? assetImagePath,
    Uint8List? customImageBytes,
    String? customImageName,
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
    );
  }
}
