/// Định nghĩa mô hình thông tin khách hàng và sở thích thiết kế bộ bài Tarot.
class CustomerProfile {
  final String name;
  final String style;
  final String favoriteColor;
  final String theme;
  final String notes;
  final DateTime createdAt;

  const CustomerProfile({
    required this.name,
    required this.style,
    required this.favoriteColor,
    required this.theme,
    required this.notes,
    required this.createdAt,
  });

  /// Hồ sơ mẫu mặc định
  factory CustomerProfile.defaultProfile() {
    return CustomerProfile(
      name: 'Nhà Chiêm Tinh',
      style: 'Huyền bí',
      favoriteColor: 'Vàng Kim & Chàm Tím',
      theme: 'Thiên văn & Tinh tú',
      notes: 'Bộ bài mang năng lượng chiêm niệm và thức tỉnh nội tâm.',
      createdAt: DateTime.now(),
    );
  }

  /// Sao chép với các trường thay đổi
  CustomerProfile copyWith({
    String? name,
    String? style,
    String? favoriteColor,
    String? theme,
    String? notes,
    DateTime? createdAt,
  }) {
    return CustomerProfile(
      name: name ?? this.name,
      style: style ?? this.style,
      favoriteColor: favoriteColor ?? this.favoriteColor,
      theme: theme ?? this.theme,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Tự động gợi ý mã CardTemplate phù hợp nhất với sở thích của khách
  String get suggestedTemplateId {
    switch (style) {
      case 'Cổ điển':
        return 'classic_arcana';
      case 'Huyền bí':
        return 'celestial_mystic';
      case 'Tối giản':
        return 'minimalist_alchemy';
      case 'Hoàng gia':
      case 'Thiên nhiên':
        return 'full_bleed_art';
      default:
        if (theme.contains('Thiên văn')) return 'celestial_mystic';
        if (theme.contains('Hoa lá')) return 'full_bleed_art';
        return 'classic_arcana';
    }
  }

  /// Tạo cấu trúc prompt tiếng Anh chi tiết cho API tạo ảnh AI (Gemini)
  /// Đảm bảo ảnh sinh ra LUÔN theo phong cách bài Tarot chuẩn, không bị biến dạng sang phong cách hoạt hình/anime.
  String buildTarotPrompt({
    required String cardName,
    required String userDescription,
  }) {
    final styleKeyword = _mapStyleToEnglish(style);
    final colorKeyword = _mapColorToEnglish(favoriteColor);
    final themeKeyword = _mapThemeToEnglish(theme);

    final cleanDesc = userDescription.trim().isNotEmpty
        ? 'Subject details: $userDescription.'
        : '';

    return '''
Masterpiece occult tarot card illustration for "$cardName".
$cleanDesc
Artistic style: Authentic vintage tarot card aesthetic, $styleKeyword, $themeKeyword, intricate woodcut engraving linework, sacred geometry.
Color palette: $colorKeyword, antique parchment wash, luminous gold leaf accents, rich contrast.
Composition: Central symbolic figure, esoteric tarot iconography, balanced mystical atmosphere.
Constraints: Genuine tarot artwork only, no modern photorealism, no cartoon, no anime, no text watermark, no printed card border.
'''.trim();
  }

  static String _mapStyleToEnglish(String s) {
    switch (s) {
      case 'Cổ điển':
        return 'Victorian gothic woodcut engraving with antique ornate flourishes';
      case 'Huyền bí':
        return 'Esoteric arcane occult engraving with sacred astrology symbols';
      case 'Tối giản':
        return 'Minimalist fine-line alchemical geometry with subtle luxury gilded accents';
      case 'Hoàng gia':
        return 'Imperial baroque regality with opulent golden filigree and velvet textures';
      case 'Thiên nhiên':
        return 'Botanical herbalist folklore with blooming flora and sacred wild beasts';
      default:
        return 'Traditional esoteric tarot engraving with sacred geometry';
    }
  }

  static String _mapColorToEnglish(String c) {
    switch (c) {
      case 'Vàng Kim & Chàm Tím':
        return 'deep mystical indigo purple and luminous antique gold';
      case 'Đỏ Nhung & Đen Huyền':
        return 'velvet crimson red, obsidian black and burnished bronze';
      case 'Xanh Ngọc & Đồng Cổ':
        return 'ethereal emerald jade teal and antique copper gold';
      case 'Bạc Tinh Tú & Xanh Băng':
        return 'celestial silver starlight and midnight navy blue';
      default:
        return 'antique lustrous gold and deep twilight purple';
    }
  }

  static String _mapThemeToEnglish(String t) {
    switch (t) {
      case 'Thiên văn & Tinh tú':
        return 'celestial constellations, crescent moons, eight-pointed stars';
      case 'Phù thủy & Huyền thuật':
        return 'arcane spellcraft, cauldrons, sacred crystals and mystical runes';
      case 'Thiên thần & Thánh tích':
        return 'seraphic divine wings, sacred halos, angelic light beams';
      case 'Hoa lá & Thảo mộc':
        return 'entwined mystical vines, sacred lotus, roses and ancient herbs';
      case 'Thần thoại cổ đại':
        return 'ancient classical mythological archetypes and sacred pantheon';
      default:
        return 'mystical tarot symbolism and archetypes';
    }
  }
}
