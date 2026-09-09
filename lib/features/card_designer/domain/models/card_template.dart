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
      name: 'Cổ Điển Huyền Bí',
      description: 'Hoa văn Gothic, họa tiết góc cầu kỳ & biểu ngữ tiêu đề',
      frameStyle: TarotFrameStyle.classicArcana,
      textPlacement: TextPlacement.headerAndFooter,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'celestial_mystic',
      name: 'Thiên Thể Huyền Diệu',
      description: 'Sao tám cánh, trăng lưỡi liềm & đối xứng thiên văn',
      frameStyle: TarotFrameStyle.celestialMystic,
      textPlacement: TextPlacement.headerAndFooter,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'minimalist_alchemy',
      name: 'Giả Kim Tối Giản',
      description: 'Khung viền mảnh sang trọng hiện đại & tinh tế nhẹ nhàng',
      frameStyle: TarotFrameStyle.minimalistAlchemy,
      textPlacement: TextPlacement.minimalCentered,
      isFullBleedImage: false,
    ),
    CardTemplate(
      id: 'full_bleed_art',
      name: 'Nghệ Thuật Toàn Khung',
      description: 'Hình ảnh tràn viền với mép dát vàng & huy hiệu nổi',
      frameStyle: TarotFrameStyle.fullBleedArt,
      textPlacement: TextPlacement.floatingBadges,
      isFullBleedImage: true,
    ),
  ];
}
