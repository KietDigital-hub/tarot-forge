import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/tarot_deck_data.dart';
import '../../domain/models/tarot_card.dart';

/// State management for the active Tarot Card design session.
class CardDesignerNotifier extends Notifier<TarotCard> {
  @override
  TarotCard build() {
    return const TarotCard(
      id: 'active_card',
      romanNumeral: 'XVII',
      name: 'THE STAR',
      subtitle: 'Hope • Inspiration • Serenity',
      templateId: 'classic_arcana',
      assetImagePath: 'assets/images/the_star.jpg',
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name.toUpperCase());
  }

  void updateNumeral(String numeral) {
    state = state.copyWith(romanNumeral: numeral.toUpperCase());
  }

  void updateSubtitle(String subtitle) {
    state = state.copyWith(subtitle: subtitle);
  }

  void selectTemplate(String templateId) {
    state = state.copyWith(templateId: templateId);
  }

  void selectAssetImage(String assetPath) {
    state = state.copyWith(
      assetImagePath: assetPath,
      clearCustomImage: true,
    );
  }

  void setCustomImage(Uint8List bytes, String fileName) {
    state = state.copyWith(
      customImageBytes: bytes,
      customImageName: fileName,
    );
  }

  void applyPreset(TarotPreset preset) {
    state = state.copyWith(
      romanNumeral: preset.romanNumeral,
      name: preset.name,
      subtitle: preset.keywords,
      assetImagePath: preset.assetImagePath,
      clearCustomImage: true,
    );
  }
}

final cardDesignerProvider =
    NotifierProvider<CardDesignerNotifier, TarotCard>(CardDesignerNotifier.new);

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
