import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tarot_forge/core/constants/tarot_78_cards_data.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_back_design.dart';
import 'package:tarot_forge/features/card_designer/domain/models/tarot_card.dart';
import 'package:tarot_forge/features/deck_manager/domain/models/tarot_deck.dart';

/// Notifier managing the complete 78-card Tarot Deck state.
class DeckNotifier extends Notifier<TarotDeck> {
  @override
  TarotDeck build() {
    return TarotDeck.initialStandardDeck();
  }

  /// Update a single card in the deck and mark it as customized.
  void updateCard(TarotCard updatedCard) {
    final newCards = state.cards.map((c) {
      if (c.id == updatedCard.id) {
        return updatedCard.copyWith(isCustomized: true);
      }
      return c;
    }).toList();

    state = state.copyWith(
      cards: newCards,
      updatedAt: DateTime.now(),
    );
  }

  /// Update the global card back styling for the deck.
  void updateCardBack(CardBackDesign newBack) {
    state = state.copyWith(
      cardBack: newBack,
      updatedAt: DateTime.now(),
    );
  }

  /// Apply a template to all 78 cards in the deck.
  void applyTemplateToAll(String templateId) {
    final updated = state.cards.map((c) {
      return c.copyWith(templateId: templateId);
    }).toList();

    state = state.copyWith(
      cards: updated,
      updatedAt: DateTime.now(),
    );
  }

  /// Reset a card back to its standard archetype definition.
  void resetCardToDefault(String cardId) {
    final def = Tarot78CardsData.getById(cardId);
    if (def == null) return;

    final newCards = state.cards.map((c) {
      if (c.id == cardId) {
        return TarotCard.fromDefinition(def, templateId: c.templateId);
      }
      return c;
    }).toList();

    state = state.copyWith(
      cards: newCards,
      updatedAt: DateTime.now(),
    );
  }

  /// Rename the deck.
  void renameDeck(String newName) {
    state = state.copyWith(
      name: newName,
      updatedAt: DateTime.now(),
    );
  }
}

final deckProvider =
    NotifierProvider<DeckNotifier, TarotDeck>(DeckNotifier.new);

/// Provider tracking the currently selected card ID in the deck.
class ActiveCardIdNotifier extends Notifier<String> {
  @override
  String build() => 'major_17'; // Default: The Star

  void selectCard(String cardId) {
    state = cardId;
  }
}

final activeCardIdProvider =
    NotifierProvider<ActiveCardIdNotifier, String>(ActiveCardIdNotifier.new);
