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

  static const TarotPreset theStar = TarotPreset(
    romanNumeral: 'XVII',
    name: 'NGÔI SAO',
    keywords: 'Hy Vọng • Khát Vọng • An Bình',
    assetImagePath: 'assets/images/the_star.jpg',
  );

  static const TarotPreset theMagician = TarotPreset(
    romanNumeral: 'I',
    name: 'PHÁP SƯ',
    keywords: 'Ý Chí • Hiện Thực Hóa • Sáng Tạo',
    assetImagePath: 'assets/images/the_magician.jpg',
  );

  static const TarotPreset theMoon = TarotPreset(
    romanNumeral: 'XVIII',
    name: 'MẶT TRĂNG',
    keywords: 'Trực Giác • Ảo Ảnh • Tiềm Thức',
    assetImagePath: 'assets/images/the_moon.jpg',
  );

  static const TarotPreset theEmpress = TarotPreset(
    romanNumeral: 'III',
    name: 'NỮ HOÀNG',
    keywords: 'Sinh Sôi • Dồi Dào • Thiên Nhiên',
    assetImagePath: 'assets/images/the_empress.jpg',
  );

  static const TarotPreset theEmperor = TarotPreset(
    romanNumeral: 'IV',
    name: 'HOÀNG ĐẾ',
    keywords: 'Uy Quyền • Trật Tự • Vững Bền',
    assetImagePath: 'assets/images/the_emperor.jpg',
  );

  static const List<TarotPreset> samplePresets = [
    theStar,
    theMagician,
    theMoon,
    theEmpress,
    theEmperor,
  ];
}
