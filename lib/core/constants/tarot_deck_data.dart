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

  static const TarotPreset gothicDark = TarotPreset(
    romanNumeral: 'XIII',
    name: 'CÁI CHẾT',
    keywords: 'Tái Sinh • Chuyển Hóa • Kết Thúc',
    assetImagePath: 'assets/images/gothic_dark.jpg',
  );

  static const TarotPreset artNouveau = TarotPreset(
    romanNumeral: 'VI',
    name: 'ĐÔI TÌNH NHÂN',
    keywords: 'Tình Yêu • Gắn Kết • Lựa Chọn',
    assetImagePath: 'assets/images/art_nouveau.jpg',
  );

  static const TarotPreset witchcraftFolk = TarotPreset(
    romanNumeral: 'IX',
    name: 'KẺ ẨN DẬT',
    keywords: 'Trí Tuệ • Tĩnh Lặng • Khám Phá',
    assetImagePath: 'assets/images/witchcraft_folk.jpg',
  );

  static const TarotPreset orientalMystic = TarotPreset(
    romanNumeral: 'X',
    name: 'BÁNH XE SỐ PHẬN',
    keywords: 'Vận Mệnh • Luân Chuyển • Cơ Hội',
    assetImagePath: 'assets/images/oriental_mystic.jpg',
  );

  static const TarotPreset egyptianAncient = TarotPreset(
    romanNumeral: 'V',
    name: 'ĐẠI TƯ TẾ',
    keywords: 'Tri Thức • Truyền Thống • Tâm Linh',
    assetImagePath: 'assets/images/egyptian_ancient.jpg',
  );

  static const TarotPreset cosmicGalaxy = TarotPreset(
    romanNumeral: 'XXI',
    name: 'THẾ GIỚI',
    keywords: 'Viên Mãn • Vũ Trụ • Hoàn Thành',
    assetImagePath: 'assets/images/cosmic_galaxy.jpg',
  );

  static const TarotPreset cyberpunkMystic = TarotPreset(
    romanNumeral: 'VII',
    name: 'CỖ XE',
    keywords: 'Ý Chí • Tiến Lên • Chinh Phục',
    assetImagePath: 'assets/images/cyberpunk_mystic.jpg',
  );

  static const TarotPreset baroqueGrand = TarotPreset(
    romanNumeral: 'XI',
    name: 'CÔNG LÝ',
    keywords: 'Chân Lý • Cân Bằng • Minh Triết',
    assetImagePath: 'assets/images/baroque_grand.jpg',
  );

  static const TarotPreset inkWashMinimal = TarotPreset(
    romanNumeral: '0',
    name: 'KẺ KHỜ',
    keywords: 'Khởi Đầu • Thuần Khiết • Phiêu Lưu',
    assetImagePath: 'assets/images/ink_wash_minimal.jpg',
  );

  static const TarotPreset tropicalForest = TarotPreset(
    romanNumeral: 'VIII',
    name: 'SỨC MẠNH',
    keywords: 'Can Đảm • Nhẫn Nại • Từ Bi',
    assetImagePath: 'assets/images/tropical_forest.jpg',
  );

  static const TarotPreset oceanMystic = TarotPreset(
    romanNumeral: 'II',
    name: 'NỮ TU TỐI CAO',
    keywords: 'Trực Giác • Bí Ẩn • Nội Tâm',
    assetImagePath: 'assets/images/ocean_mystic.jpg',
  );

  /// Toàn bộ danh sách 16 tranh mẫu kinh điển đa dạng phong cách cho thư viện
  static const List<TarotPreset> samplePresets = [
    theStar,
    theMagician,
    theMoon,
    theEmpress,
    theEmperor,
    gothicDark,
    artNouveau,
    witchcraftFolk,
    orientalMystic,
    egyptianAncient,
    cosmicGalaxy,
    cyberpunkMystic,
    baroqueGrand,
    inkWashMinimal,
    tropicalForest,
    oceanMystic,
  ];
}
