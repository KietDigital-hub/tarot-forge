/// Comprehensive Tarot Deck Data containing all 78 cards of the traditional
/// Rider-Waite system with authentic Vietnamese terminology, esoteric correspondences,
/// Roman numerals, archetypal keywords, and Gemini AI prompt cues.
library;

enum TarotSuit {
  major,
  wands,
  cups,
  swords,
  pentacles,
}

extension TarotSuitExtension on TarotSuit {
  String get displayName {
    switch (this) {
      case TarotSuit.major:
        return 'Ẩn Chính';
      case TarotSuit.wands:
        return 'Bộ Gậy';
      case TarotSuit.cups:
        return 'Bộ Chén';
      case TarotSuit.swords:
        return 'Bộ Kiếm';
      case TarotSuit.pentacles:
        return 'Bộ Tiền';
    }
  }

  String get element {
    switch (this) {
      case TarotSuit.major:
        return 'Tinh Thể (Aether)';
      case TarotSuit.wands:
        return 'Lửa (Fire)';
      case TarotSuit.cups:
        return 'Nước (Water)';
      case TarotSuit.swords:
        return 'Khí (Air)';
      case TarotSuit.pentacles:
        return 'Đất (Earth)';
    }
  }

  String get iconSymbol {
    switch (this) {
      case TarotSuit.major:
        return '✨';
      case TarotSuit.wands:
        return '🔥';
      case TarotSuit.cups:
        return '💧';
      case TarotSuit.swords:
        return '💨';
      case TarotSuit.pentacles:
        return '🌍';
    }
  }
}

class TarotCardDefinition {
  final String id;
  final TarotSuit suit;
  final int number; // 0-21 for Major; 1-14 for Minor (1=Ace, 11=Page, 12=Knight, 13=Queen, 14=King)
  final String romanNumeral;
  final String name;
  final String englishName;
  final String keywords;
  final String element;
  final String promptKeywords;
  final String? defaultAssetPath;

  const TarotCardDefinition({
    required this.id,
    required this.suit,
    required this.number,
    required this.romanNumeral,
    required this.name,
    required this.englishName,
    required this.keywords,
    required this.element,
    required this.promptKeywords,
    this.defaultAssetPath,
  });

  bool get isMajor => suit == TarotSuit.major;
  bool get isCourtCard => !isMajor && number >= 11;
}

class Tarot78CardsData {
  Tarot78CardsData._();

  // =========================================================================
  // 22 MAJOR ARCANA (ẨN CHÍNH)
  // =========================================================================
  static const List<TarotCardDefinition> majorArcana = [
    TarotCardDefinition(
      id: 'major_0',
      suit: TarotSuit.major,
      number: 0,
      romanNumeral: '0',
      name: 'KẺ KHỜ',
      englishName: 'The Fool',
      keywords: 'Khởi Đầu Mới • Ngây Thơ • Tự Do • Can Đảm Vấn Thân',
      element: 'Khí',
      promptKeywords: 'The Fool tarot archetype, young traveler on cliff edge with white rose, small white dog leaping, sunrise glowing, fearless spiritual journey',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_1',
      suit: TarotSuit.major,
      number: 1,
      romanNumeral: 'I',
      name: 'PHÁP SƯ',
      englishName: 'The Magician',
      keywords: 'Ý Chí • Hiện Thực Hóa • Khéo Léo • Năng Lực Sáng Tạo',
      element: 'Khí',
      promptKeywords: 'The Magician tarot archetype, wand raised to heaven, one hand pointing to earth, altar with wand cup sword and pentacle, infinity symbol floating above head',
      defaultAssetPath: 'assets/images/the_magician.jpg',
    ),
    TarotCardDefinition(
      id: 'major_2',
      suit: TarotSuit.major,
      number: 2,
      romanNumeral: 'II',
      name: 'NỮ TU TỐI CAO',
      englishName: 'The High Priestess',
      keywords: 'Trực Giác • Bí Ẩn Tâm Linh • Tĩnh Lặng • Tri Thức Ngầm',
      element: 'Nước',
      promptKeywords: 'The High Priestess tarot archetype, seated between black and white pillars Boaz and Jachin, veil of pomegranates, crescent moon at feet, scroll of ancient wisdom',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_3',
      suit: TarotSuit.major,
      number: 3,
      romanNumeral: 'III',
      name: 'NỮ HOÀNG',
      englishName: 'The Empress',
      keywords: 'Sinh Sôi • Dồi Dào • Thiên Nhiên • Tình Mẫu Tử Nuôi Dưỡng',
      element: 'Đất',
      promptKeywords: 'The Empress tarot archetype, maternal queen crowned with twelve stars, luxurious robe among golden wheat field, waterfall flowing, symbol of Venus',
      defaultAssetPath: 'assets/images/the_empress.jpg',
    ),
    TarotCardDefinition(
      id: 'major_4',
      suit: TarotSuit.major,
      number: 4,
      romanNumeral: 'IV',
      name: 'HOÀNG ĐẾ',
      englishName: 'The Emperor',
      keywords: 'Uy Quyền • Trật Tự • Vững Bền • Cấu Trúc Lãnh Đạo',
      element: 'Lửa',
      promptKeywords: 'The Emperor tarot archetype, stern bearded king on stone throne with carved rams heads, orb and scepter, red robes, stark mountainous background',
      defaultAssetPath: 'assets/images/the_emperor.jpg',
    ),
    TarotCardDefinition(
      id: 'major_5',
      suit: TarotSuit.major,
      number: 5,
      romanNumeral: 'V',
      name: 'ĐẠI TƯ TẾ',
      englishName: 'The Hierophant',
      keywords: 'Truyền Thống • Đạo Đức • Khai Sáng Giáo Lý • Tôn Nghiêm',
      element: 'Đất',
      promptKeywords: 'The Hierophant tarot archetype, spiritual teacher seated between sacred pillars, triple crown, right hand giving blessing, two crossed keys of wisdom',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_6',
      suit: TarotSuit.major,
      number: 6,
      romanNumeral: 'VI',
      name: 'ĐÔI TÌNH NHÂN',
      englishName: 'The Lovers',
      keywords: 'Gắn Kết • Lựa Chọn Trái Tim • Hòa Hợp • Thấu Cảm',
      element: 'Khí',
      promptKeywords: 'The Lovers tarot archetype, angel Raphael blessing man and woman in garden, tree of life with twelve fruit and tree of knowledge with serpent, bright sun',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_7',
      suit: TarotSuit.major,
      number: 7,
      romanNumeral: 'VII',
      name: 'CỖ XE',
      englishName: 'The Chariot',
      keywords: 'Chiến Thắng • Quyết Tâm • Làm Chủ Nghịch Cảnh • Ý Chí',
      element: 'Nước',
      promptKeywords: 'The Chariot tarot archetype, armored warrior in star-canopied chariot drawn by two sphinxes black and white, holding wand, triumph and determination',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_8',
      suit: TarotSuit.major,
      number: 8,
      romanNumeral: 'VIII',
      name: 'SỨC MẠNH',
      englishName: 'Strength',
      keywords: 'Dũng Khí • Dịu Dàng Khắc Chế • Kiên Nhẫn • Nội Lực',
      element: 'Lửa',
      promptKeywords: 'Strength tarot archetype, serene woman gently taming fierce golden lion with bare hands and flowers, infinity lemniscate glowing above her head',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_9',
      suit: TarotSuit.major,
      number: 9,
      romanNumeral: 'IX',
      name: 'KẺ ẨN DẬT',
      englishName: 'The Hermit',
      keywords: 'Soi Rọi Nội Tâm • Chiêm Nghiệm • Ánh Sáng Trí Huệ • Cô Độc',
      element: 'Đất',
      promptKeywords: 'The Hermit tarot archetype, wise elder cloaked on snowy mountain peak, holding lantern with six-pointed star of truth, golden staff in hand',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_10',
      suit: TarotSuit.major,
      number: 10,
      romanNumeral: 'X',
      name: 'BÁNH XE SỐ PHẬN',
      englishName: 'Wheel of Fortune',
      keywords: 'Vận Mệnh • Chu Kỳ Chuyển Dịch • Cơ Duyên • Thay Đổi Lớn',
      element: 'Lửa',
      promptKeywords: 'Wheel of Fortune tarot archetype, celestial golden wheel inscribed with Hebrew letters and alchemy symbols, sphinx at top, Hermanubis rising, winged creatures',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_11',
      suit: TarotSuit.major,
      number: 11,
      romanNumeral: 'XI',
      name: 'CÔNG LÝ',
      englishName: 'Justice',
      keywords: 'Chân Lý • Minh Bạch • Cân Bằng Nhân Quả • Quyết Định Đúng',
      element: 'Khí',
      promptKeywords: 'Justice tarot archetype, crowned figure seated between two pillars, upright double-edged sword in right hand, golden scales of truth balanced in left hand',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_12',
      suit: TarotSuit.major,
      number: 12,
      romanNumeral: 'XII',
      name: 'NGƯỜI TREO NGƯỢC',
      englishName: 'The Hanged Man',
      keywords: 'Buông Bỏ • Đổi Góc Nhìn • Hi Sinh Tự Nguyện • Ngộ Đạo',
      element: 'Nước',
      promptKeywords: 'The Hanged Man tarot archetype, figure hanging upside down by one ankle from living wooden T-cross, golden halo around head, peaceful contemplative face',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_13',
      suit: TarotSuit.major,
      number: 13,
      romanNumeral: 'XIII',
      name: 'CÁI CHẾT',
      englishName: 'Death',
      keywords: 'Chuyển Hóa • Khép Lại Quá Khứ • Tái Sinh • Khởi Sắc Mới',
      element: 'Nước',
      promptKeywords: 'Death tarot archetype, black armored knight on white horse carrying black banner with mystic white rose, sunrise between two distant towers, eternal transformation',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_14',
      suit: TarotSuit.major,
      number: 14,
      romanNumeral: 'XIV',
      name: 'TIẾT ĐỘ',
      englishName: 'Temperance',
      keywords: 'Hòa Hợp • Điều Độ • Chữa Lành • Giả Kim Cân Bằng',
      element: 'Lửa',
      promptKeywords: 'Temperance tarot archetype, winged angel pouring liquid between two golden chalices in continuous stream, one foot on earth one in water, path leading to sun',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_15',
      suit: TarotSuit.major,
      number: 15,
      romanNumeral: 'XV',
      name: 'ÁC QUỶ',
      englishName: 'The Devil',
      keywords: 'Ràng Buộc • Ảo Vọng Vật Chất • Đối Diện Bóng Tối • Khát Khao',
      element: 'Đất',
      promptKeywords: 'The Devil tarot archetype, horned baphomet winged figure on pedestal with inverted pentagram, chained male and female figures with loose chains, torch of desire',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_16',
      suit: TarotSuit.major,
      number: 16,
      romanNumeral: 'XVI',
      name: 'TÒA THÁP',
      englishName: 'The Tower',
      keywords: 'Đột Biến • Sụp Đổ Ảo Tưởng • Thức Tỉnh Chấn Động • Giải Thoát',
      element: 'Lửa',
      promptKeywords: 'The Tower tarot archetype, tall stone tower on rocky summit struck by divine lightning bolt, golden crown blasted off, flames bursting, profound revelation',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_17',
      suit: TarotSuit.major,
      number: 17,
      romanNumeral: 'XVII',
      name: 'NGÔI SAO',
      englishName: 'The Star',
      keywords: 'Hy Vọng • Khát Vọng • An Bình • Nguồn Cảm Hứng Vô Tận',
      element: 'Khí',
      promptKeywords: 'The Star tarot archetype, naked maiden kneeling pouring water onto earth and pool from two urns, large eight-pointed golden star surrounded by seven stars, ibis in tree',
      defaultAssetPath: 'assets/images/the_star.jpg',
    ),
    TarotCardDefinition(
      id: 'major_18',
      suit: TarotSuit.major,
      number: 18,
      romanNumeral: 'XVIII',
      name: 'MẶT TRĂNG',
      englishName: 'The Moon',
      keywords: 'Trực Giác • Ảo Ảnh • Tiềm Thức • Bí Ẩn Về Đêm',
      element: 'Nước',
      promptKeywords: 'The Moon tarot archetype, full moon with face dropping yods of light, dog and wolf howling at two towers, crayfish emerging from deep water, path to unknown',
      defaultAssetPath: 'assets/images/the_moon.jpg',
    ),
    TarotCardDefinition(
      id: 'major_19',
      suit: TarotSuit.major,
      number: 19,
      romanNumeral: 'XIX',
      name: 'MẶT TRỜI',
      englishName: 'The Sun',
      keywords: 'Hân Hoan • Thành Công Rực Rỡ • Sức Sống Vươn Cao • Tươi Sáng',
      element: 'Lửa',
      promptKeywords: 'The Sun tarot archetype, radiant smiling golden sun, joyful child crowned with flowers riding white horse carrying red banner, walled garden of sunflowers',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_20',
      suit: TarotSuit.major,
      number: 20,
      romanNumeral: 'XX',
      name: 'PHÁN XÉT',
      englishName: 'Judgement',
      keywords: 'Kêu Gọi Tâm Linh • Tái Sinh Toàn Vẹn • Tha Thứ • Phục Sinh',
      element: 'Lửa',
      promptKeywords: 'Judgement tarot archetype, archangel Gabriel sounding golden trumpet from billowing clouds, souls rising from tombs with arms outstretched in praise',
      defaultAssetPath: null,
    ),
    TarotCardDefinition(
      id: 'major_21',
      suit: TarotSuit.major,
      number: 21,
      romanNumeral: 'XXI',
      name: 'THẾ GIỚI',
      englishName: 'The World',
      keywords: 'Viên Mãn • Hoàn Tất Chu Trình • Vũ Trụ Hài Hòa • Đỉnh Cao',
      element: 'Đất',
      promptKeywords: 'The World tarot archetype, dancing maiden draped in purple scarf holding two wands inside golden laurel wreath, four corners lion bull angel eagle',
      defaultAssetPath: null,
    ),
  ];

  // =========================================================================
  // 14 WANDS (BỘ GẬY - NGUYÊN TỐ LỬA 🔥)
  // =========================================================================
  static const List<TarotCardDefinition> wandsSuit = [
    TarotCardDefinition(
      id: 'wands_1',
      suit: TarotSuit.wands,
      number: 1,
      romanNumeral: 'ÁCH',
      name: 'ÁCH GẬY',
      englishName: 'Ace of Wands',
      keywords: 'Ngọn Lửa Sáng Tạo • Tiềm Năng • Đam Mê Mới • Xung Lực Bứt Phá',
      element: 'Lửa',
      promptKeywords: 'Ace of Wands tarot, divine hand emerging from luminous cloud grasping sprouting wooden staff with green leaves, distant fortress, fiery creative energy',
    ),
    TarotCardDefinition(
      id: 'wands_2',
      suit: TarotSuit.wands,
      number: 2,
      romanNumeral: 'II',
      name: 'HAI GẬY',
      englishName: 'Two of Wands',
      keywords: 'Tầm Nhìn Xa • Lập Kế Hoạch • Khát Vọng Vương Ra Thế Giới',
      element: 'Lửa',
      promptKeywords: 'Two of Wands tarot, nobleman on castle battlements holding globe looking out at sea, staff fixed to parapet, bold vision and world planning',
    ),
    TarotCardDefinition(
      id: 'wands_3',
      suit: TarotSuit.wands,
      number: 3,
      romanNumeral: 'III',
      name: 'BA GẬY',
      englishName: 'Three of Wands',
      keywords: 'Mở Rộng Cơ Hội • Chờ Đợi Kết Quả • Thuyền Trở Về • Tự Tin',
      element: 'Lửa',
      promptKeywords: 'Three of Wands tarot, figure in merchant cloak looking out from cliff over golden sea at distant sailing ships, three tall flowering staffs',
    ),
    TarotCardDefinition(
      id: 'wands_4',
      suit: TarotSuit.wands,
      number: 4,
      romanNumeral: 'IV',
      name: 'BỐN GẬY',
      englishName: 'Four of Wands',
      keywords: 'Ăn Mừng • Mái Ấm Bình Yên • Cột Mốc Vui Tươi • Đoàn Tụ',
      element: 'Lửa',
      promptKeywords: 'Four of Wands tarot, four tall wands woven with floral garland of flowers and grapes, dancing figures rejoicing in front of welcoming castle',
    ),
    TarotCardDefinition(
      id: 'wands_5',
      suit: TarotSuit.wands,
      number: 5,
      romanNumeral: 'V',
      name: 'NĂM GẬY',
      englishName: 'Five of Wands',
      keywords: 'Cạnh Tranh Lành Mạnh • Thử Thách Va Chạm • Bất Đồng Quan Điểm',
      element: 'Lửa',
      promptKeywords: 'Five of Wands tarot, five youths brandishing wooden staves in energetic sparring battle, testing strength and friendly competition',
    ),
    TarotCardDefinition(
      id: 'wands_6',
      suit: TarotSuit.wands,
      number: 6,
      romanNumeral: 'VI',
      name: 'SÁU GẬY',
      englishName: 'Six of Wands',
      keywords: 'Khúc Khải Hoàn • Vinh Quang • Được Tôn Vinh • Thành Công Vang Dội',
      element: 'Lửa',
      promptKeywords: 'Six of Wands tarot, triumphant horseman crowned with laurel wreath riding white stallion, staff tied with laurel, cheering crowd following',
    ),
    TarotCardDefinition(
      id: 'wands_7',
      suit: TarotSuit.wands,
      number: 7,
      romanNumeral: 'VII',
      name: 'BẢY GẬY',
      englishName: 'Seven of Wands',
      keywords: 'Bảo Vệ Lập Trường • Kiên Định • Đơn Độc Chiến Đấu • Bất Khuất',
      element: 'Lửa',
      promptKeywords: 'Seven of Wands tarot, determined warrior atop rocky crag defending his ground with long staff against six staves rising from below',
    ),
    TarotCardDefinition(
      id: 'wands_8',
      suit: TarotSuit.wands,
      number: 8,
      romanNumeral: 'VIII',
      name: 'TÁM GẬY',
      englishName: 'Eight of Wands',
      keywords: 'Tốc Độ Bay • Tin Vui Tới Nhanh • Luồng Gió Mới • Chuyển Động',
      element: 'Lửa',
      promptKeywords: 'Eight of Wands tarot, eight flowering wooden wands flying swiftly through clear azure sky above rolling countryside and river, sudden swift movement',
    ),
    TarotCardDefinition(
      id: 'wands_9',
      suit: TarotSuit.wands,
      number: 9,
      romanNumeral: 'IX',
      name: 'CHÍN GẬY',
      englishName: 'Nine of Wands',
      keywords: 'Cảnh Giác • Kiên Cường Sau Gian Khổ • Phòng Tuyến Cuối Cùng',
      element: 'Lửa',
      promptKeywords: 'Nine of Wands tarot, wounded but sturdy warrior bandaged head holding staff defensively before palisade of eight upright staves',
    ),
    TarotCardDefinition(
      id: 'wands_10',
      suit: TarotSuit.wands,
      number: 10,
      romanNumeral: 'X',
      name: 'MƯỜI GẬY',
      englishName: 'Ten of Wands',
      keywords: 'Gánh Nặng Trách Nhiệm • Quá Tải • Gần Đến Đích • Nỗ Lực Tột Cùng',
      element: 'Lửa',
      promptKeywords: 'Ten of Wands tarot, exhausted figure bent forward carrying bundle of ten heavy wooden staves trudging uphill toward town in distance',
    ),
    TarotCardDefinition(
      id: 'wands_11',
      suit: TarotSuit.wands,
      number: 11,
      romanNumeral: 'THỊ TÒNG',
      name: 'THỊ TÒNG GẬY',
      englishName: 'Page of Wands',
      keywords: 'Nhiệt Huyết Tuổi Trẻ • Nhà Thám Hiểm • Sứ Giả Ý Tưởng Mới',
      element: 'Lửa',
      promptKeywords: 'Page of Wands tarot, spirited young herald in yellow patterned tunic holding upright sprouting staff, gazing at top with wonder, desert landscape',
    ),
    TarotCardDefinition(
      id: 'wands_12',
      suit: TarotSuit.wands,
      number: 12,
      romanNumeral: 'HIỆP SĨ',
      name: 'HIỆP SĨ GẬY',
      englishName: 'Knight of Wands',
      keywords: 'Xông Pha • Táo Bạo • Hào Hùng • Hành Động Thần Tốc',
      element: 'Lửa',
      promptKeywords: 'Knight of Wands tarot, valiant knight in armor with salamander tunic on rearing chestnut horse, holding fiery wooden staff, boundless momentum',
    ),
    TarotCardDefinition(
      id: 'wands_13',
      suit: TarotSuit.wands,
      number: 13,
      romanNumeral: 'HOÀNG HẬU',
      name: 'HOÀNG HẬU GẬY',
      englishName: 'Queen of Wands',
      keywords: 'Quyến Rũ Tỏa Sáng • Tự Tin • Độc Lập • Ấm Áp Rạng Ngời',
      element: 'Lửa',
      promptKeywords: 'Queen of Wands tarot, radiant queen on throne carved with lions holding blooming sunflower and staff, black cat seated before her, sunny warmth',
    ),
    TarotCardDefinition(
      id: 'wands_14',
      suit: TarotSuit.wands,
      number: 14,
      romanNumeral: 'VUA',
      name: 'VUA GẬY',
      englishName: 'King of Wands',
      keywords: 'Thủ Lĩnh Lôi Cuốn • Tầm Nhìn Chiến Lược • Uy Lực • Quyết Đoán',
      element: 'Lửa',
      promptKeywords: 'King of Wands tarot, authoritative king in flame-patterned cloak on lion throne holding blossoming wooden scepter, salamander at his side',
    ),
  ];

  // =========================================================================
  // 14 CUPS (BỘ CHÉN - NGUYÊN TỐ NƯỚC 💧)
  // =========================================================================
  static const List<TarotCardDefinition> cupsSuit = [
    TarotCardDefinition(
      id: 'cups_1',
      suit: TarotSuit.cups,
      number: 1,
      romanNumeral: 'ÁCH',
      name: 'ÁCH CHÉN',
      englishName: 'Ace of Cups',
      keywords: 'Dòng Chảy Tình Yêu • Cảm Xúc Tuôn Trào • Trực Giác Thăng Hoa',
      element: 'Nước',
      promptKeywords: 'Ace of Cups tarot, divine hand holding golden chalice with five streams overflowing into waterlily pond, white dove descending with communion wafer',
    ),
    TarotCardDefinition(
      id: 'cups_2',
      suit: TarotSuit.cups,
      number: 2,
      romanNumeral: 'II',
      name: 'HAI CHÉN',
      englishName: 'Two of Cups',
      keywords: 'Tâm Đầu Ý Hợp • Lời Thề Gắn Kết • Tri Kỷ • Tình Yêu Tương Hỗ',
      element: 'Nước',
      promptKeywords: 'Two of Cups tarot, youth and maiden exchanging golden cups in pledge of love, caduceus of Hermes and winged red lion floating above them',
    ),
    TarotCardDefinition(
      id: 'cups_3',
      suit: TarotSuit.cups,
      number: 3,
      romanNumeral: 'III',
      name: 'BA CHÉN',
      englishName: 'Three of Cups',
      keywords: 'Tình Bạn Chân Thành • Tiệc Vui • Chia Ngọt Sẻ Bùi • Tương Trợ',
      element: 'Nước',
      promptKeywords: 'Three of Cups tarot, three graceful maidens in colorful gowns dancing in circle raising cups in toast, harvest of grapes and garden fruits',
    ),
    TarotCardDefinition(
      id: 'cups_4',
      suit: TarotSuit.cups,
      number: 4,
      romanNumeral: 'IV',
      name: 'BỐN CHÉN',
      englishName: 'Four of Cups',
      keywords: 'Thờ Ơ • Suy Tư Trầm Mặc • Bỏ Lỡ Cơ Hội Trước Mắt • Chán Chường',
      element: 'Nước',
      promptKeywords: 'Four of Cups tarot, contemplative youth sitting cross-legged under green tree arms folded ignoring three cups before him, fourth cup offered by cloud hand',
    ),
    TarotCardDefinition(
      id: 'cups_5',
      suit: TarotSuit.cups,
      number: 5,
      romanNumeral: 'V',
      name: 'NĂM CHÉN',
      englishName: 'Five of Cups',
      keywords: 'Nỗi Buồn Hụt Hẫng • Tiếc Nuối • Hai Chén Còn Nguyên • Chữa Lành',
      element: 'Nước',
      promptKeywords: 'Five of Cups tarot, dark-cloaked figure grieving over three spilled cups of red wine, bridge and castle in background, two upright cups behind him',
    ),
    TarotCardDefinition(
      id: 'cups_6',
      suit: TarotSuit.cups,
      number: 6,
      romanNumeral: 'VI',
      name: 'SÁU CHÉN',
      englishName: 'Six of Cups',
      keywords: 'Ký Ức Tuổi Thơ • Tấm Lòng Thuần Khiết • Hoài Niệm • Hạnh Phúc Đơn Sơ',
      element: 'Nước',
      promptKeywords: 'Six of Cups tarot, sweet young boy offering flower-filled cup to little girl in ancient courtyard, white flowers blooming in six ornate cups',
    ),
    TarotCardDefinition(
      id: 'cups_7',
      suit: TarotSuit.cups,
      number: 7,
      romanNumeral: 'VII',
      name: 'BẢY CHÉN',
      englishName: 'Seven of Cups',
      keywords: 'Mộng Tưởng • Đứng Trước Nhiều Lựa Chọn • Hư Ảo • Cần Tỉnh Táo',
      element: 'Nước',
      promptKeywords: 'Seven of Cups tarot, silhouette figure gazing in astonishment at seven cups floating in mystic cloud filled with castle jewels dragon snake and laurels',
    ),
    TarotCardDefinition(
      id: 'cups_8',
      suit: TarotSuit.cups,
      number: 8,
      romanNumeral: 'VIII',
      name: 'TÁM CHÉN',
      englishName: 'Eight of Cups',
      keywords: 'Rời Đi Để Tìm Ý Nghĩa • Khước Từ Thói Cũ • Hành Trình Tâm Linh',
      element: 'Nước',
      promptKeywords: 'Eight of Cups tarot, cloaked traveler walking away with staff toward rocky mountains, leaving behind eight stacked cups, crescent moon eclipsing sun',
    ),
    TarotCardDefinition(
      id: 'cups_9',
      suit: TarotSuit.cups,
      number: 9,
      romanNumeral: 'IX',
      name: 'CHÍN CHÉN',
      englishName: 'Nine of Cups',
      keywords: 'Ước Nguyện Thành Toàn • Hài Lòng Tuyệt Đối • Viên Mãn Tinh Thần',
      element: 'Nước',
      promptKeywords: 'Nine of Cups tarot, cheerful prosperous man seated arms folded in satisfaction before curved wooden table displaying nine gleaming golden cups',
    ),
    TarotCardDefinition(
      id: 'cups_10',
      suit: TarotSuit.cups,
      number: 10,
      romanNumeral: 'X',
      name: 'MƯỜI CHÉN',
      englishName: 'Ten of Cups',
      keywords: 'Hạnh Phúc Gia Đình • Bình An Trọn Vẹn • Cầu Vồng Phước Lành',
      element: 'Nước',
      promptKeywords: 'Ten of Cups tarot, loving couple embracing with dancing children outside cottage, celestial rainbow of ten golden cups arching across azure sky',
    ),
    TarotCardDefinition(
      id: 'cups_11',
      suit: TarotSuit.cups,
      number: 11,
      romanNumeral: 'THỊ TÒNG',
      name: 'THỊ TÒNG CHÉN',
      englishName: 'Page of Cups',
      keywords: 'Tâm Hồn Thơ Mộng • Trực Giác Nhạy Bén • Thông Điệp Tình Cảm',
      element: 'Nước',
      promptKeywords: 'Page of Cups tarot, gentle poetic youth in floral tunic holding golden cup from which friendly silver fish pops its head, ocean waves behind',
    ),
    TarotCardDefinition(
      id: 'cups_12',
      suit: TarotSuit.cups,
      number: 12,
      romanNumeral: 'HIỆP SĨ',
      name: 'HIỆP SĨ CHÉN',
      englishName: 'Knight of Cups',
      keywords: 'Sứ Giả Lãng Mạn • Chàng Hiệp Sĩ Mơ Mộng • Lời Tỏ Tình Tinh Tế',
      element: 'Nước',
      promptKeywords: 'Knight of Cups tarot, romantic knight in armor adorned with fish on quiet walking white steed, holding out golden cup forward, calm stream',
    ),
    TarotCardDefinition(
      id: 'cups_13',
      suit: TarotSuit.cups,
      number: 13,
      romanNumeral: 'HOÀNG HẬU',
      name: 'HOÀNG HẬU CHÉN',
      englishName: 'Queen of Cups',
      keywords: 'Lòng Trắc Ẩn • Trực Giác Vô Tận • Thấu Cảm Sâu Sắc • Dịu Hiền',
      element: 'Nước',
      promptKeywords: 'Queen of Cups tarot, compassionate queen seated by seashore on seashell throne gazing intently into ornate closed golden chalice, mystical water calm',
    ),
    TarotCardDefinition(
      id: 'cups_14',
      suit: TarotSuit.cups,
      number: 14,
      romanNumeral: 'VUA',
      name: 'VUA CHÉN',
      englishName: 'King of Cups',
      keywords: 'Làm Chủ Cảm Xúc • Điềm Đạm • Bao Dung • Cân Bằng Tâm Trí',
      element: 'Nước',
      promptKeywords: 'King of Cups tarot, wise king on stone throne floating upon turbulent ocean holding golden cup and lotus scepter, leaping fish and sailing ship',
    ),
  ];

  // =========================================================================
  // 14 SWORDS (BỘ KIẾM - NGUYÊN TỐ KHÍ 💨)
  // =========================================================================
  static const List<TarotCardDefinition> swordsSuit = [
    TarotCardDefinition(
      id: 'swords_1',
      suit: TarotSuit.swords,
      number: 1,
      romanNumeral: 'ÁCH',
      name: 'ÁCH KIẾM',
      englishName: 'Ace of Swords',
      keywords: 'Minh Mẫn Tuyệt Đối • Sự Thật Sắc Bén • Đột Phá Tư Duy • Công Lý',
      element: 'Khí',
      promptKeywords: 'Ace of Swords tarot, divine hand emerging from cloud holding upright double-edged sword crowned with golden coronet and olive palm branches',
    ),
    TarotCardDefinition(
      id: 'swords_2',
      suit: TarotSuit.swords,
      number: 2,
      romanNumeral: 'II',
      name: 'HAI KIẾM',
      englishName: 'Two of Swords',
      keywords: 'Thế Lưỡng Lự • Bịt Mắt Phân Vân • Tránh Đối Mặt • Tạm Đình Chiến',
      element: 'Khí',
      promptKeywords: 'Two of Swords tarot, blindfolded woman in white seated by calm sea under crescent moon, balancing two crossed heavy swords on her shoulders',
    ),
    TarotCardDefinition(
      id: 'swords_3',
      suit: TarotSuit.swords,
      number: 3,
      romanNumeral: 'III',
      name: 'BA KIẾM',
      englishName: 'Three of Swords',
      keywords: 'Nỗi Đau Tan Nát • Sự Thật Đắng Cay • Tổn Thương • Giải Phóng Nỗi Buồn',
      element: 'Khí',
      promptKeywords: 'Three of Swords tarot, glowing red heart pierced by three swords floating beneath dark storm clouds and driving rain, profound heartache',
    ),
    TarotCardDefinition(
      id: 'swords_4',
      suit: TarotSuit.swords,
      number: 4,
      romanNumeral: 'IV',
      name: 'BỐN KIẾM',
      englishName: 'Four of Swords',
      keywords: 'Tĩnh Dưỡng Phục Hồi • Ngơi Nghỉ Sau Giông Bão • Thiền Định',
      element: 'Khí',
      promptKeywords: 'Four of Swords tarot, knight effigy resting in prayer upon tomb in quiet sanctuary, three swords hanging above, one carved at base, stained glass window',
    ),
    TarotCardDefinition(
      id: 'swords_5',
      suit: TarotSuit.swords,
      number: 5,
      romanNumeral: 'V',
      name: 'NĂM KIẾM',
      englishName: 'Five of Swords',
      keywords: 'Chiến Thắng Cay Đắng • Tranh Chấp Hư Danh • Bài Học Về Bản Ngã',
      element: 'Khí',
      promptKeywords: 'Five of Swords tarot, smirking figure holding three swords watching two defeated comrades walk away, two swords left on ground under turbulent windy sky',
    ),
    TarotCardDefinition(
      id: 'swords_6',
      suit: TarotSuit.swords,
      number: 6,
      romanNumeral: 'VI',
      name: 'SÁU KIẾM',
      englishName: 'Six of Swords',
      keywords: 'Rời Vùng Sóng Gió • Chuyển Giao Yên Ả • Tìm Bến Đỗ Bình Yên',
      element: 'Khí',
      promptKeywords: 'Six of Swords tarot, ferryman poling wooden boat carrying cloaked woman and child across water from rough waves to calm shore, six upright swords in boat',
    ),
    TarotCardDefinition(
      id: 'swords_7',
      suit: TarotSuit.swords,
      number: 7,
      romanNumeral: 'VII',
      name: 'BẢY KIẾM',
      englishName: 'Seven of Swords',
      keywords: 'Mưu Mẹo Luồn Lách • Kế Sách Táo Bạo • Hành Động Lén Lút • Chiến Thuật',
      element: 'Khí',
      promptKeywords: 'Seven of Swords tarot, stealthy figure sneaking on tiptoe from military encampment carrying five swords looking back at two swords left standing',
    ),
    TarotCardDefinition(
      id: 'swords_8',
      suit: TarotSuit.swords,
      number: 8,
      romanNumeral: 'VIII',
      name: 'TÁM KIẾM',
      englishName: 'Eight of Swords',
      keywords: 'Bẫy Suy Nghĩ • Tự Giới Hạn Bản Thân • Cần Phá Vỡ Ảo Tưởng',
      element: 'Khí',
      promptKeywords: 'Eight of Swords tarot, blindfolded bound woman standing in muddy ground surrounded by enclosure of eight swords, castle high on hill behind',
    ),
    TarotCardDefinition(
      id: 'swords_9',
      suit: TarotSuit.swords,
      number: 9,
      romanNumeral: 'IX',
      name: 'CHÍN KIẾM',
      englishName: 'Nine of Swords',
      keywords: 'Mất Ngủ • Ác Mộng Dày Vò • Nỗi Lo Tự Tạo • Hãy Mở Cửa Đón Ánh Sáng',
      element: 'Khí',
      promptKeywords: 'Nine of Swords tarot, despairing figure sitting up in bed with head in hands in dark room, nine swords mounted horizontally on wall above',
    ),
    TarotCardDefinition(
      id: 'swords_10',
      suit: TarotSuit.swords,
      number: 10,
      romanNumeral: 'X',
      name: 'MƯỜI KIẾM',
      englishName: 'Ten of Swords',
      keywords: 'Điểm Đáy Gian Nan • Kết Thúc Tất Yếu • Bình Minh Đang Chờ Đón',
      element: 'Khí',
      promptKeywords: 'Ten of Swords tarot, figure lying prone covered in red cloth with ten swords in back, golden dawn glowing on distant horizon across calm black water',
    ),
    TarotCardDefinition(
      id: 'swords_11',
      suit: TarotSuit.swords,
      number: 11,
      romanNumeral: 'THỊ TÒNG',
      name: 'THỊ TÒNG KIẾM',
      englishName: 'Page of Swords',
      keywords: 'Tò Mò Trí Tuệ • Khám Phá Sự Thật • Cảnh Giác • Sắc Sảo',
      element: 'Khí',
      promptKeywords: 'Page of Swords tarot, alert youthful scout standing on grassy knoll holding sword with both hands looking over shoulder, gusty clouds, flying birds',
    ),
    TarotCardDefinition(
      id: 'swords_12',
      suit: TarotSuit.swords,
      number: 12,
      romanNumeral: 'HIỆP SĨ',
      name: 'HIỆP SĨ KIẾM',
      englishName: 'Knight of Swords',
      keywords: 'Tiến Công Bão Táp • Quyết Liệt • Sắc Bén • Không Ngại Va Chạm',
      element: 'Khí',
      promptKeywords: 'Knight of Swords tarot, armored knight charging full gallop on white warhorse waving drawn broadsword into fierce wind and stormy skies',
    ),
    TarotCardDefinition(
      id: 'swords_13',
      suit: TarotSuit.swords,
      number: 13,
      romanNumeral: 'HOÀNG HẬU',
      name: 'HOÀNG HẬU KIẾM',
      englishName: 'Queen of Swords',
      keywords: 'Trực Ngôn Minh Bạch • Phán Đoán Khách Quan • Sắc Sảo Độc Lập',
      element: 'Khí',
      promptKeywords: 'Queen of Swords tarot, stern perceptive queen in white robe on throne adorned with cherub, holding upright sword in right hand, left hand beckoning truth',
    ),
    TarotCardDefinition(
      id: 'swords_14',
      suit: TarotSuit.swords,
      number: 14,
      romanNumeral: 'VUA',
      name: 'VUA KIẾM',
      englishName: 'King of Swords',
      keywords: 'Uy Nghi Trí Tuệ • Công Bằng Liêm Khiết • Luật Pháp • Kỷ Cương',
      element: 'Khí',
      promptKeywords: 'King of Swords tarot, solemn commanding king on high stone throne holding upright sword slightly tilted, blue mantle, piercing intellectual gaze',
    ),
  ];

  // =========================================================================
  // 14 PENTACLES (BỘ TIỀN - NGUYÊN TỐ ĐẤT 🌍)
  // =========================================================================
  static const List<TarotCardDefinition> pentaclesSuit = [
    TarotCardDefinition(
      id: 'pentacles_1',
      suit: TarotSuit.pentacles,
      number: 1,
      romanNumeral: 'ÁCH',
      name: 'ÁCH TIỀN',
      englishName: 'Ace of Pentacles',
      keywords: 'Mầm Mống Tài Lộc • Cơ Hội Vàng • Sung Túc Thực Tế • Vững Chắc',
      element: 'Đất',
      promptKeywords: 'Ace of Pentacles tarot, divine hand holding huge gleaming golden coin with inscribed star over lush garden of white lilies arch of roses and mountains',
    ),
    TarotCardDefinition(
      id: 'pentacles_2',
      suit: TarotSuit.pentacles,
      number: 2,
      romanNumeral: 'II',
      name: 'HAI TIỀN',
      englishName: 'Two of Pentacles',
      keywords: 'Cân Bằng Linh Hoạt • Xoay Vần Thời Thế • Thích Ứng Mềm Dẻo',
      element: 'Đất',
      promptKeywords: 'Two of Pentacles tarot, dancing juggler in tall hat balancing two golden coins inside green infinity loop, ships riding rolling ocean waves behind',
    ),
    TarotCardDefinition(
      id: 'pentacles_3',
      suit: TarotSuit.pentacles,
      number: 3,
      romanNumeral: 'III',
      name: 'BA TIỀN',
      englishName: 'Three of Pentacles',
      keywords: 'Tay Nghề Bậc Thầy • Hợp Tác Chuyên Môn • Tác Phẩm Để Đời',
      element: 'Đất',
      promptKeywords: 'Three of Pentacles tarot, young stone mason at work in Gothic cathedral discussing architectural plans with monk and nobleman, three coins carved in stone',
    ),
    TarotCardDefinition(
      id: 'pentacles_4',
      suit: TarotSuit.pentacles,
      number: 4,
      romanNumeral: 'IV',
      name: 'BỐN TIỀN',
      englishName: 'Four of Pentacles',
      keywords: 'Giữ Chặt Tài Sản • Kiểm Soát Chặt Chẽ • An Toàn Nhưng Khép Kín',
      element: 'Đất',
      promptKeywords: 'Four of Pentacles tarot, crowned figure sitting tightly clutching one golden coin to chest, two coins under his feet, one balanced on head, city background',
    ),
    TarotCardDefinition(
      id: 'pentacles_5',
      suit: TarotSuit.pentacles,
      number: 5,
      romanNumeral: 'V',
      name: 'NĂM TIỀN',
      englishName: 'Five of Pentacles',
      keywords: 'Khó Khăn Tạm Thời • Cảm Giác Thiếu Thốn • Nơi Nương Tựa Luôn Có',
      element: 'Đất',
      promptKeywords: 'Five of Pentacles tarot, two impoverished figures walking through deep snow past glowing stained-glass window of church showing five golden coins',
    ),
    TarotCardDefinition(
      id: 'pentacles_6',
      suit: TarotSuit.pentacles,
      number: 6,
      romanNumeral: 'VI',
      name: 'SÁU TIỀN',
      englishName: 'Six of Pentacles',
      keywords: 'Hào Phóng Sẻ Chia • Nhận Và Cho • Cân Bằng Phúc Đức • Tài Trợ',
      element: 'Đất',
      promptKeywords: 'Six of Pentacles tarot, wealthy merchant holding scales of justice dropping golden coins into hands of two needy supplicants, generosity and balance',
    ),
    TarotCardDefinition(
      id: 'pentacles_7',
      suit: TarotSuit.pentacles,
      number: 7,
      romanNumeral: 'VII',
      name: 'BẢY TIỀN',
      englishName: 'Seven of Pentacles',
      keywords: 'Kiên Nhẫn Chờ Mùa Thu Hoạch • Đánh Giá Thành Quả • Tích Lũy',
      element: 'Đất',
      promptKeywords: 'Seven of Pentacles tarot, patient farmer resting on hoe contemplating rich green grapevine bearing seven golden coins, quiet long-term perseverance',
    ),
    TarotCardDefinition(
      id: 'pentacles_8',
      suit: TarotSuit.pentacles,
      number: 8,
      romanNumeral: 'VIII',
      name: 'TÁM TIỀN',
      englishName: 'Eight of Pentacles',
      keywords: 'Chăm Chỉ Chuyên Tâm • Rèn Giũa Tay Nghề • Tỉ Mỉ Từng Chi Tiết',
      element: 'Đất',
      promptKeywords: 'Eight of Pentacles tarot, dedicated craftsman sitting carving intricate pentacle onto golden coin with hammer and chisel, six coins displayed on bench',
    ),
    TarotCardDefinition(
      id: 'pentacles_9',
      suit: TarotSuit.pentacles,
      number: 9,
      romanNumeral: 'IX',
      name: 'CHÍN TIỀN',
      englishName: 'Nine of Pentacles',
      keywords: 'Thảnh Thơi Thịnh Vượng • Tự Do Tài Chính • Tận Hưởng Thành Quả',
      element: 'Đất',
      promptKeywords: 'Nine of Pentacles tarot, elegant noblewoman in golden gown standing in lavish vineyard with hooded falcon on hand, nine golden coins hanging on vines',
    ),
    TarotCardDefinition(
      id: 'pentacles_10',
      suit: TarotSuit.pentacles,
      number: 10,
      romanNumeral: 'X',
      name: 'MƯỜI TIỀN',
      englishName: 'Ten of Pentacles',
      keywords: 'Gia Tộc Hưng Thịnh • Di Sản Bền Vững • Sung Túc Viên Mãn Đời Đời',
      element: 'Đất',
      promptKeywords: 'Ten of Pentacles tarot, three generations of family with dogs before stone archway of estate, ten golden coins arranged in tree of life pattern',
    ),
    TarotCardDefinition(
      id: 'pentacles_11',
      suit: TarotSuit.pentacles,
      number: 11,
      romanNumeral: 'THỊ TÒNG',
      name: 'THỊ TÒNG TIỀN',
      englishName: 'Page of Pentacles',
      keywords: 'Ham Học Hỏi • Kế Hoạch Đầy Hứa Hẹn • Khởi Động Vững Vàng',
      element: 'Đất',
      promptKeywords: 'Page of Pentacles tarot, earnest young scholar standing in flower-strewn meadow gazing intently at golden coin suspended above his raised hands',
    ),
    TarotCardDefinition(
      id: 'pentacles_12',
      suit: TarotSuit.pentacles,
      number: 12,
      romanNumeral: 'HIỆP SĨ',
      name: 'HIỆP SĨ TIỀN',
      englishName: 'Knight of Pentacles',
      keywords: 'Bền Bỉ Đáng Tin Cậy • Chậm Mà Chắc • Trung Kiên • Cần Mẫn',
      element: 'Đất',
      promptKeywords: 'Knight of Pentacles tarot, steadfast knight in black armor on sturdy heavy draft horse in ploughed field holding single golden coin, dependable perseverance',
    ),
    TarotCardDefinition(
      id: 'pentacles_13',
      suit: TarotSuit.pentacles,
      number: 13,
      romanNumeral: 'HOÀNG HẬU',
      name: 'HOÀNG HẬU TIỀN',
      englishName: 'Queen of Pentacles',
      keywords: 'Trù Phú Ấm No • Chăm Sóc Thực Tế • Hào Phóng Mẫu Mực • Bình Dị',
      element: 'Đất',
      promptKeywords: 'Queen of Pentacles tarot, gracious queen on throne surrounded by lush fruit and floral vines cradling large golden coin, little rabbit in foreground',
    ),
    TarotCardDefinition(
      id: 'pentacles_14',
      suit: TarotSuit.pentacles,
      number: 14,
      romanNumeral: 'VUA',
      name: 'VUA TIỀN',
      englishName: 'King of Pentacles',
      keywords: 'Đế Vương Tài Chính • Thành Đạt Đỉnh Cao • Vững Chãi Thịnh Vượng',
      element: 'Đất',
      promptKeywords: 'King of Pentacles tarot, affluent king in robe embroidered with grapevines on bull-carved throne holding golden scepter and large coin, castle courtyard',
    ),
  ];

  /// The complete 78 Tarot cards list
  static List<TarotCardDefinition> get all78Cards => [
        ...majorArcana,
        ...wandsSuit,
        ...cupsSuit,
        ...swordsSuit,
        ...pentaclesSuit,
      ];

  /// Find card definition by ID
  static TarotCardDefinition? getById(String id) {
    try {
      return all78Cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get cards by suit
  static List<TarotCardDefinition> getBySuit(TarotSuit suit) {
    switch (suit) {
      case TarotSuit.major:
        return majorArcana;
      case TarotSuit.wands:
        return wandsSuit;
      case TarotSuit.cups:
        return cupsSuit;
      case TarotSuit.swords:
        return swordsSuit;
      case TarotSuit.pentacles:
        return pentaclesSuit;
    }
  }
}
