import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_78_cards_data.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../domain/models/card_back_design.dart';
import '../../domain/models/tarot_card.dart';

/// State management for the active Tarot Card design session.
class CardDesignerNotifier extends Notifier<TarotCard> {
  @override
  TarotCard build() {
    return const TarotCard(
      id: 'major_17',
      romanNumeral: 'XVII',
      name: 'NGÔI SAO',
      subtitle: 'Hy Vọng • Khát Vọng • An Bình',
      templateId: 'classic_arcana',
      assetImagePath: 'assets/images/the_star.jpg',
      suit: TarotSuit.major,
      element: 'Khí',
      number: 17,
      englishName: 'The Star',
    );
  }

  void loadCard(TarotCard card) {
    state = card;
  }

  void updateName(String name) {
    state = state.copyWith(
      name: name.toUpperCase(),
      isCustomized: true,
    );
  }

  void updateNumeral(String numeral) {
    state = state.copyWith(
      romanNumeral: numeral.toUpperCase(),
      isCustomized: true,
    );
  }

  void updateSubtitle(String subtitle) {
    state = state.copyWith(
      subtitle: subtitle,
      isCustomized: true,
    );
  }

  void selectTemplate(String templateId) {
    state = state.copyWith(
      templateId: templateId,
      isCustomized: true,
    );
  }

  void selectAssetImage(String assetPath) {
    state = state.copyWith(
      assetImagePath: assetPath,
      clearCustomImage: true,
      isCustomized: true,
    );
  }

  void setCustomImage(Uint8List bytes, String fileName) {
    state = state.copyWith(
      customImageBytes: bytes,
      customImageName: fileName,
      isCustomized: true,
    );
  }

  void applyPreset(TarotPreset preset) {
    state = state.copyWith(
      romanNumeral: preset.romanNumeral,
      name: preset.name,
      subtitle: preset.keywords,
      assetImagePath: preset.assetImagePath,
      clearCustomImage: true,
      isCustomized: true,
    );
  }
}

final cardDesignerProvider =
    NotifierProvider<CardDesignerNotifier, TarotCard>(CardDesignerNotifier.new);

/// Notifier for flipping the card in 3D canvas (Front vs Back).
class CardFlipNotifier extends Notifier<bool> {
  @override
  bool build() => false; // false = front, true = back

  void toggleFlip() {
    state = !state;
  }

  void showFront() {
    state = false;
  }

  void showBack() {
    state = true;
  }
}

final cardFlipProvider =
    NotifierProvider<CardFlipNotifier, bool>(CardFlipNotifier.new);

/// Notifier for Card Back Design configuration.
class CardBackNotifier extends Notifier<CardBackDesign> {
  @override
  CardBackDesign build() {
    return const CardBackDesign(
      pattern: CardBackPattern.celestialCompass,
      backgroundColor: Color(0xFF0F0B1E),
      foilColor: Color(0xFFD4AF37),
      secondaryFoilColor: Color(0xFFFFF0A8),
    );
  }

  void updateDesign(CardBackDesign design) {
    state = design;
  }

  void updatePattern(CardBackPattern pattern) {
    state = state.copyWith(pattern: pattern);
  }

  void updateColors({
    Color? backgroundColor,
    Color? foilColor,
    Color? secondaryFoilColor,
  }) {
    state = state.copyWith(
      backgroundColor: backgroundColor,
      foilColor: foilColor,
      secondaryFoilColor: secondaryFoilColor,
    );
  }

  void setCustomImage(Uint8List bytes, String fileName) {
    state = state.copyWith(
      pattern: CardBackPattern.customArt,
      customImageBytes: bytes,
      customImageName: fileName,
    );
  }
}

final cardBackProvider =
    NotifierProvider<CardBackNotifier, CardBackDesign>(CardBackNotifier.new);

/// Theme mode notifier for dynamic Dark / Light switching.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void toggleTheme() {
    state = (state == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
