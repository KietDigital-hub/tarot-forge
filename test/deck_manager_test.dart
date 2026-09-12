import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_forge/core/constants/tarot_78_cards_data.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_back_design.dart';
import 'package:tarot_forge/features/deck_manager/domain/models/tarot_deck.dart';
import 'package:tarot_forge/features/deck_manager/presentation/providers/deck_provider.dart';

void main() {
  group('Tarot 78 Cards Data Integrity', () {
    test('Contains exactly 78 cards in total', () {
      final all = Tarot78CardsData.all78Cards;
      expect(all.length, 78);
    });

    test('Contains exactly 22 Major Arcana cards with numbers 0 to 21', () {
      final major = Tarot78CardsData.majorArcana;
      expect(major.length, 22);

      final numbers = major.map((c) => c.number).toList();
      for (int i = 0; i <= 21; i++) {
        expect(numbers.contains(i), isTrue);
      }

      // Check first and last Major Arcana
      expect(major.first.name, 'KẺ KHỜ');
      expect(major.first.romanNumeral, '0');
      expect(major.last.name, 'THẾ GIỚI');
      expect(major.last.romanNumeral, 'XXI');
    });

    test('Contains 4 suits of Minor Arcana with 14 cards each (56 total)', () {
      final wands = Tarot78CardsData.wandsSuit;
      final cups = Tarot78CardsData.cupsSuit;
      final swords = Tarot78CardsData.swordsSuit;
      final pentacles = Tarot78CardsData.pentaclesSuit;

      expect(wands.length, 14);
      expect(cups.length, 14);
      expect(swords.length, 14);
      expect(pentacles.length, 14);
      expect(wands.length + cups.length + swords.length + pentacles.length, 56);

      // Verify each suit has Ace and King
      expect(wands.first.name, 'ÁCH GẬY');
      expect(wands.last.name, 'VUA GẬY');

      expect(cups.first.name, 'ÁCH CHÉN');
      expect(cups.last.name, 'VUA CHÉN');

      expect(swords.first.name, 'ÁCH KIẾM');
      expect(swords.last.name, 'VUA KIẾM');

      expect(pentacles.first.name, 'ÁCH TIỀN');
      expect(pentacles.last.name, 'VUA TIỀN');
    });

    test('Every card definition has a unique ID and non-empty prompt keywords', () {
      final all = Tarot78CardsData.all78Cards;
      final ids = <String>{};

      for (final card in all) {
        expect(ids.add(card.id), isTrue, reason: 'Duplicate ID: ${card.id}');
        expect(card.name.isNotEmpty, isTrue);
        expect(card.keywords.isNotEmpty, isTrue);
        expect(card.promptKeywords.isNotEmpty, isTrue);
      }
    });

    test('getById and getBySuit return accurate card definitions', () {
      final theStar = Tarot78CardsData.getById('major_17');
      expect(theStar, isNotNull);
      expect(theStar!.name, 'NGÔI SAO');
      expect(theStar.suit, TarotSuit.major);

      final aceOfCups = Tarot78CardsData.getById('cups_1');
      expect(aceOfCups, isNotNull);
      expect(aceOfCups!.name, 'ÁCH CHÉN');
      expect(aceOfCups.suit, TarotSuit.cups);

      final wands = Tarot78CardsData.getBySuit(TarotSuit.wands);
      expect(wands.length, 14);
    });
  });

  group('TarotDeck Domain Model & Statistics', () {
    test('Initializes with 78 cards and default statistics', () {
      final deck = TarotDeck.initialStandardDeck();
      expect(deck.totalCount, 78);
      expect(deck.customizedCount, 0);
      expect(deck.progress, 0.0);
      expect(deck.progressPercentage, 0);
      expect(deck.majorArcana.length, 22);
      expect(deck.wands.length, 14);
      expect(deck.cups.length, 14);
      expect(deck.swords.length, 14);
      expect(deck.pentacles.length, 14);
    });

    test('Calculates customized count and progress percentage accurately', () {
      final deck = TarotDeck.initialStandardDeck();
      final card1 = deck.cards[0].copyWith(isCustomized: true);
      final card2 = deck.cards[1].copyWith(isCustomized: true);

      final updatedCards = deck.cards.map((c) {
        if (c.id == card1.id) return card1;
        if (c.id == card2.id) return card2;
        return c;
      }).toList();

      final updatedDeck = deck.copyWith(cards: updatedCards);
      expect(updatedDeck.customizedCount, 2);
      expect(updatedDeck.progressPercentage, (2 / 78 * 100).round());
      expect(updatedDeck.customizedCards.length, 2);
    });
  });

  group('DeckNotifier Provider Logic', () {
    test('updateCard properly updates a card in the deck and marks it customized', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialDeck = container.read(deckProvider);
      expect(initialDeck.customizedCount, 0);

      final cardToUpdate = initialDeck.cards.first.copyWith(
        name: 'KẺ KHỜ HUYỀN DIỆU',
      );

      container.read(deckProvider.notifier).updateCard(cardToUpdate);
      final updatedDeck = container.read(deckProvider);

      expect(updatedDeck.customizedCount, 1);
      final updatedCard = updatedDeck.getCardById(cardToUpdate.id);
      expect(updatedCard, isNotNull);
      expect(updatedCard!.name, 'KẺ KHỜ HUYỀN DIỆU');
      expect(updatedCard.isCustomized, isTrue);
    });

    test('applyTemplateToAll sets templateId across all 78 cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(deckProvider.notifier).applyTemplateToAll('minimalist_alchemy');
      final state = container.read(deckProvider);

      for (final card in state.cards) {
        expect(card.templateId, 'minimalist_alchemy');
      }
    });

    test('resetCardToDefault resets modified card to original definition', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final originalCard = container.read(deckProvider).cards.first;
      container.read(deckProvider.notifier).updateCard(originalCard.copyWith(name: 'TÊN ĐÃ SỬA'));
      expect(container.read(deckProvider).getCardById(originalCard.id)!.name, 'TÊN ĐÃ SỬA');

      container.read(deckProvider.notifier).resetCardToDefault(originalCard.id);
      expect(container.read(deckProvider).getCardById(originalCard.id)!.name, 'KẺ KHỜ');
    });

    test('updateCardBack updates the deck cardBack styling', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const newDesign = CardBackDesign(
        pattern: CardBackPattern.mysticSunMoon,
      );
      container.read(deckProvider.notifier).updateCardBack(newDesign);
      expect(container.read(deckProvider).cardBack.pattern, CardBackPattern.mysticSunMoon);
    });
  });
}
