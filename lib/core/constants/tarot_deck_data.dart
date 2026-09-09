/// Major Arcana presets with archetypal names, Roman numerals, and default keywords in Vietnamese.
class TarotPreset {
  final String romanNumeral;
  final String name;
  final String keywords;
  final String assetImagePath;

  const TarotPreset({
    required this.romanNumeral,
    required this.name,
    required this.keywords,
    required this.assetImagePath,
  });
}

class TarotDeckData {
  TarotDeckData._();

  static const List<TarotPreset> samplePresets = [
    TarotPreset(
      romanNumeral: 'XVII',
      name: 'NGÔI SAO',
      keywords: 'Hy Vọng • Khát Vọng • An Bình',
      assetImagePath: 'assets/images/the_star.jpg',
    ),
    TarotPreset(
      romanNumeral: 'I',
      name: 'PHÁP SƯ',
      keywords: 'Ý Chí • Hiện Thực Hóa • Sáng Tạo',
      assetImagePath: 'assets/images/the_magician.jpg',
    ),
    TarotPreset(
      romanNumeral: 'XVIII',
      name: 'MẶT TRĂNG',
      keywords: 'Trực Giác • Ảo Ảnh • Tiềm Thức',
      assetImagePath: 'assets/images/the_moon.jpg',
    ),
  ];
}
