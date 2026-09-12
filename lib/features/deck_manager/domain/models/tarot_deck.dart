import 'package:tarot_forge/core/constants/tarot_78_cards_data.dart';
import 'package:tarot_forge/features/card_designer/domain/models/card_back_design.dart';
import 'package:tarot_forge/features/card_designer/domain/models/tarot_card.dart';

/// Immutable domain model representing a complete 78-card Tarot Deck.
class TarotDeck {
  final String id;
  final String name;
  final List<TarotCard> cards;
  final CardBackDesign cardBack;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TarotDeck({
    required this.id,
    required this.name,
    required this.cards,
    this.cardBack = const CardBackDesign(),
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to initialize a standard 78-card deck with preset archetypes.
  factory TarotDeck.initialStandardDeck({
    String name = 'Bộ Bài Huyền Bí',
    String defaultTemplateId = 'classic_arcana',
  }) {
    final allDefs = Tarot78CardsData.all78Cards;
    final cardList = allDefs.map((def) {
      return TarotCard.fromDefinition(def, templateId: defaultTemplateId);
    }).toList();

    final now = DateTime.now();
    return TarotDeck(
      id: 'deck_${now.millisecondsSinceEpoch}',
      name: name,
      cards: cardList,
      cardBack: const CardBackDesign(),
      createdAt: now,
      updatedAt: now,
    );
  }

  // Statistics & Progress
  int get totalCount => cards.length;
  int get customizedCount =>
      cards.where((c) => c.isCustomized || c.hasCustomImage).length;
  double get progress => totalCount > 0 ? (customizedCount / totalCount) : 0.0;
  int get progressPercentage => (progress * 100).round();

  // Suit Filter Collections
  List<TarotCard> get majorArcana =>
      cards.where((c) => c.suit == TarotSuit.major).toList();
  List<TarotCard> get wands =>
      cards.where((c) => c.suit == TarotSuit.wands).toList();
  List<TarotCard> get cups =>
      cards.where((c) => c.suit == TarotSuit.cups).toList();
  List<TarotCard> get swords =>
      cards.where((c) => c.suit == TarotSuit.swords).toList();
  List<TarotCard> get pentacles =>
      cards.where((c) => c.suit == TarotSuit.pentacles).toList();
  List<TarotCard> get customizedCards =>
      cards.where((c) => c.isCustomized || c.hasCustomImage).toList();

  TarotCard? getCardById(String id) {
    try {
      return cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  TarotDeck copyWith({
    String? id,
    String? name,
    List<TarotCard>? cards,
    CardBackDesign? cardBack,
    DateTime? updatedAt,
  }) {
    return TarotDeck(
      id: id ?? this.id,
      name: name ?? this.name,
      cards: cards ?? this.cards,
      cardBack: cardBack ?? this.cardBack,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
