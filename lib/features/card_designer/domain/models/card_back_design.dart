import 'dart:typed_data';
import 'package:flutter/material.dart';

/// Patterns available for the ornate symmetrical Tarot card back.
enum CardBackPattern {
  sacredGeometry,
  celestialCompass,
  alchemicalOuroboros,
  mysticSunMoon,
  customArt,
}

extension CardBackPatternExtension on CardBackPattern {
  String get displayName {
    switch (this) {
      case CardBackPattern.sacredGeometry:
        return 'Hoa Sự Sống';
      case CardBackPattern.celestialCompass:
        return 'La Bàn Thiên Thể';
      case CardBackPattern.alchemicalOuroboros:
        return 'Ấn Ký Ouroboros';
      case CardBackPattern.mysticSunMoon:
        return 'Nhật Nguyệt Đối Xứng';
      case CardBackPattern.customArt:
        return 'Tranh Tùy Biến / AI';
    }
  }

  String get description {
    switch (this) {
      case CardBackPattern.sacredGeometry:
        return 'Mạng lưới vòng tròn thiêng liêng và đa giác vàng đối xứng';
      case CardBackPattern.celestialCompass:
        return 'La bàn sao 8 cánh, 4 vầng trăng khuyết và tinh tú chiêm tinh';
      case CardBackPattern.alchemicalOuroboros:
        return 'Rắn cắn đuôi vĩnh cửu bao quanh ấn ký 4 nguyên tố giả kim';
      case CardBackPattern.mysticSunMoon:
        return 'Mặt trời tỏa tia hào quang giao hòa cùng vầng trăng đối xứng hai đầu';
      case CardBackPattern.customArt:
        return 'Hình ảnh mặt sau độc bản do bạn tải lên hoặc tạo bằng Gemini AI';
    }
  }
}

/// Immutable model representing the card back styling and artwork.
class CardBackDesign {
  final CardBackPattern pattern;
  final Color backgroundColor;
  final Color foilColor;
  final Color secondaryFoilColor;
  final Uint8List? customImageBytes;
  final String? customImageName;

  const CardBackDesign({
    this.pattern = CardBackPattern.celestialCompass,
    this.backgroundColor = const Color(0xFF0F0B1E),
    this.foilColor = const Color(0xFFD4AF37),
    this.secondaryFoilColor = const Color(0xFFFFF0A8),
    this.customImageBytes,
    this.customImageName,
  });

  bool get hasCustomImage => customImageBytes != null;

  CardBackDesign copyWith({
    CardBackPattern? pattern,
    Color? backgroundColor,
    Color? foilColor,
    Color? secondaryFoilColor,
    Uint8List? customImageBytes,
    String? customImageName,
    bool clearCustomImage = false,
  }) {
    return CardBackDesign(
      pattern: pattern ?? this.pattern,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foilColor: foilColor ?? this.foilColor,
      secondaryFoilColor: secondaryFoilColor ?? this.secondaryFoilColor,
      customImageBytes: clearCustomImage
          ? null
          : (customImageBytes ?? this.customImageBytes),
      customImageName: clearCustomImage
          ? null
          : (customImageName ?? this.customImageName),
    );
  }
}
