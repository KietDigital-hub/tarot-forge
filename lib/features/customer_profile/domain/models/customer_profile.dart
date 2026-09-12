import '../../../../core/constants/tarot_deck_data.dart';
import '../../../../core/theme/tarot_color_palette.dart';

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

  /// Lấy bảng màu sắc giao diện tương ứng với tông màu khách hàng đã chọn
  TarotColorPalette get palette => TarotColorPalette.fromName(favoriteColor);

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

  /// Tự động gợi ý mã CardTemplate phù hợp nhất với sở thích và màu sắc của khách
  String get suggestedTemplateId {
    // 1. Xác định khung viền cơ sở theo phong cách nghệ thuật
    String baseTemplate;
    switch (style) {
      case 'Cổ điển':
      case 'Baroque tráng lệ':
      case 'Cổ tích Châu Âu':
      case 'Phương Đông huyền bí':
        baseTemplate = 'classic_arcana';
        break;
      case 'Huyền bí':
      case 'Gothic tối':
      case 'Thiên hà vũ trụ':
      case 'Đại dương huyền bí':
        baseTemplate = 'celestial_mystic';
        break;
      case 'Tối giản':
      case 'Thủy mặc tối giản':
      case 'Hiện đại tối giản neon':
      case 'Ai Cập cổ đại':
        baseTemplate = 'minimalist_alchemy';
        break;
      case 'Hoàng gia':
      case 'Thiên nhiên':
      case 'Nghệ thuật Nouveau':
      case 'Phù thủy dân gian':
      case 'Cyberpunk huyền huyễn':
      case 'Rừng nhiệt đới':
      case 'Hoàng hôn sa mạc':
      case 'Băng giá phương Bắc':
        baseTemplate = 'full_bleed_art';
        break;
      default:
        if (theme.contains('Thiên văn')) {
          baseTemplate = 'celestial_mystic';
        } else if (theme.contains('Hoa lá')) {
          baseTemplate = 'full_bleed_art';
        } else {
          baseTemplate = 'classic_arcana';
        }
    }

    // 2. Tông màu sắc đóng vai trò biến thể tinh chỉnh khung viền:
    // Đảm bảo thay đổi màu sắc dù giữ nguyên phong cách cũng tạo ra biến thể trực quan
    switch (favoriteColor) {
      case 'Đen Tuyền & Đỏ Máu':
        return (baseTemplate == 'minimalist_alchemy')
            ? 'classic_arcana'
            : (baseTemplate == 'celestial_mystic' ? 'full_bleed_art' : baseTemplate);
      case 'Trắng Ngà & Vàng Nhạt':
      case 'Hồng Phấn & Bạc':
        return (baseTemplate == 'classic_arcana')
            ? 'minimalist_alchemy'
            : (baseTemplate == 'full_bleed_art' ? 'celestial_mystic' : baseTemplate);
      case 'Bạc Tinh Tú & Xanh Băng':
      case 'Cầu Vồng Ánh Kim & Trắng':
        return (baseTemplate == 'full_bleed_art')
            ? 'celestial_mystic'
            : (baseTemplate == 'classic_arcana' ? 'minimalist_alchemy' : baseTemplate);
      case 'Xanh Lục Rừng & Nâu Gỗ':
      case 'Cam Hoàng Hôn & Nâu Đất':
        return (baseTemplate == 'celestial_mystic')
            ? 'full_bleed_art'
            : (baseTemplate == 'minimalist_alchemy' ? 'classic_arcana' : baseTemplate);
      case 'Xanh Dương Hoàng Gia & Vàng Đồng':
        return (baseTemplate == 'minimalist_alchemy')
            ? 'classic_arcana'
            : baseTemplate;
      case 'Tím Than & Xanh Lá Đậm':
        return (baseTemplate == 'full_bleed_art')
            ? 'celestial_mystic'
            : baseTemplate;
      default:
        return baseTemplate;
    }
  }

  /// Tự động gợi ý lá bài Tarot kinh điển phù hợp nhất với phong cách và tông màu
  TarotPreset get suggestedPreset {
    // 1. Phân loại lá bài đại diện cơ sở theo 20 phong cách nghệ thuật
    TarotPreset basePreset;
    switch (style) {
      case 'Hoàng gia':
        basePreset = TarotDeckData.theEmperor;
        break;
      case 'Thiên nhiên':
        basePreset = TarotDeckData.theEmpress;
        break;
      case 'Cổ điển':
        basePreset = TarotDeckData.theMagician;
        break;
      case 'Huyền bí':
        basePreset = TarotDeckData.theMoon;
        break;
      case 'Tối giản':
        basePreset = TarotDeckData.theStar;
        break;
      case 'Gothic tối':
        basePreset = TarotDeckData.gothicDark;
        break;
      case 'Nghệ thuật Nouveau':
        basePreset = TarotDeckData.artNouveau;
        break;
      case 'Phù thủy dân gian':
        basePreset = TarotDeckData.witchcraftFolk;
        break;
      case 'Phương Đông huyền bí':
        basePreset = TarotDeckData.orientalMystic;
        break;
      case 'Ai Cập cổ đại':
        basePreset = TarotDeckData.egyptianAncient;
        break;
      case 'Thiên hà vũ trụ':
        basePreset = TarotDeckData.cosmicGalaxy;
        break;
      case 'Cyberpunk huyền huyễn':
        basePreset = TarotDeckData.cyberpunkMystic;
        break;
      case 'Baroque tráng lệ':
        basePreset = TarotDeckData.baroqueGrand;
        break;
      case 'Thủy mặc tối giản':
        basePreset = TarotDeckData.inkWashMinimal;
        break;
      case 'Rừng nhiệt đới':
        basePreset = TarotDeckData.tropicalForest;
        break;
      case 'Đại dương huyền bí':
        basePreset = TarotDeckData.oceanMystic;
        break;
      case 'Hoàng hôn sa mạc':
        basePreset = TarotDeckData.egyptianAncient;
        break;
      case 'Băng giá phương Bắc':
        basePreset = TarotDeckData.cosmicGalaxy;
        break;
      case 'Cổ tích Châu Âu':
        basePreset = TarotDeckData.artNouveau;
        break;
      case 'Hiện đại tối giản neon':
        basePreset = TarotDeckData.cyberpunkMystic;
        break;
      default:
        if (theme.contains('Hoa lá')) {
          basePreset = TarotDeckData.theEmpress;
        } else if (theme.contains('Phù thủy')) {
          basePreset = TarotDeckData.theMagician;
        } else if (theme.contains('Thần thoại')) {
          basePreset = TarotDeckData.theMoon;
        } else {
          basePreset = TarotDeckData.theStar;
        }
    }

    // 2. Tông màu sắc điều hướng biến thể lá bài cho 5 nhóm cơ sở:
    // Giúp khách khi đổi màu có thể nhận được lá bài tương ứng với năng lượng màu sắc,
    // trong khi 15 phong cách chuyên sâu luôn giữ bức tranh đặc trưng của riêng mình.
    const base5Styles = {'Hoàng gia', 'Thiên nhiên', 'Cổ điển', 'Huyền bí', 'Tối giản'};
    if (!base5Styles.contains(style)) {
      return basePreset;
    }

    switch (favoriteColor) {
      case 'Đen Tuyền & Đỏ Máu':
        if (basePreset == TarotDeckData.theStar || basePreset == TarotDeckData.theMoon) {
          return TarotDeckData.theEmperor;
        }
        if (basePreset == TarotDeckData.theEmpress) {
          return TarotDeckData.theMagician;
        }
        return basePreset;

      case 'Hồng Phấn & Bạc':
        if (basePreset == TarotDeckData.theEmperor || basePreset == TarotDeckData.theMagician) {
          return TarotDeckData.theEmpress;
        }
        if (basePreset == TarotDeckData.theMoon) {
          return TarotDeckData.theStar;
        }
        return basePreset;

      case 'Xanh Lục Rừng & Nâu Gỗ':
        if (basePreset == TarotDeckData.theStar || basePreset == TarotDeckData.theMoon || basePreset == TarotDeckData.theEmperor) {
          return TarotDeckData.theEmpress;
        }
        return basePreset;

      case 'Bạc Tinh Tú & Xanh Băng':
        if (basePreset == TarotDeckData.theEmperor ||
            basePreset == TarotDeckData.theEmpress ||
            basePreset == TarotDeckData.theMoon) {
          return TarotDeckData.theStar;
        }
        return basePreset;

      case 'Xanh Dương Hoàng Gia & Vàng Đồng':
        if (basePreset == TarotDeckData.theStar || basePreset == TarotDeckData.theEmpress) {
          return TarotDeckData.theEmperor;
        }
        return basePreset;

      case 'Tím Than & Xanh Lá Đậm':
        if (basePreset == TarotDeckData.theStar || basePreset == TarotDeckData.theEmperor) {
          return TarotDeckData.theMoon;
        }
        return basePreset;

      case 'Cam Hoàng Hôn & Nâu Đất':
        if (basePreset == TarotDeckData.theStar) {
          return TarotDeckData.theEmpress;
        }
        return basePreset;

      case 'Trắng Ngà & Vàng Nhạt':
        if (basePreset == TarotDeckData.theEmperor) {
          return TarotDeckData.theMagician;
        }
        return basePreset;

      case 'Cầu Vồng Ánh Kim & Trắng':
        if (basePreset == TarotDeckData.theEmperor || basePreset == TarotDeckData.theMoon) {
          return TarotDeckData.theStar;
        }
        return basePreset;

      default:
        return basePreset;
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
      case 'Gothic tối':
        return 'Dark gothic cathedral architecture, eerie shadows, weeping gargoyles and mysterious candlelight';
      case 'Nghệ thuật Nouveau':
        return 'Art Nouveau Alphonse Mucha aesthetic with sinuous flowing organic curves and stylized floral halos';
      case 'Phù thủy dân gian':
        return 'Deep woods hedge witchcraft, bubbling apothecary potions, herbs and antique grimoires';
      case 'Phương Đông huyền bí':
        return 'Mystic East Asian oriental mythology, ink wash brushwork, imperial dragons, phoenixes and red silk motifs';
      case 'Ai Cập cổ đại':
        return 'Ancient Egyptian mythological iconography, towering pyramids, hieroglyphs and golden Pharaoh relics';
      case 'Thiên hà vũ trụ':
        return 'Cosmic nebula galaxies, interstellar star fields, glowing stardust and celestial constellations';
      case 'Cyberpunk huyền huyễn':
        return 'Mythical cyberpunk fusion, neon glowing arcane runes against dark dystopian nightscapes';
      case 'Baroque tráng lệ':
        return 'Opulent Baroque grandeur, dramatic chiaroscuro high contrast lighting and intricate theatrical details';
      case 'Thủy mặc tối giản':
        return 'Minimalist oriental sumi-e ink wash, fluid translucent ink splatters and meditative negative space';
      case 'Rừng nhiệt đới':
        return 'Lush tropical rainforest canopy, dense botanical foliage and vibrant sacred wildlife';
      case 'Đại dương huyền bí':
        return 'Mysterious deep ocean abyss, ethereal sea creatures, rolling tidal waves and luminous silver sheen';
      case 'Hoàng hôn sa mạc':
        return 'Mystic desert sunset, rolling golden sand dunes, twilight dusk and desert flora';
      case 'Băng giá phương Bắc':
        return 'Northern boreal frost, shimmering aurora borealis, crystalline glacier ice and arctic stillness';
      case 'Cổ tích Châu Âu':
        return 'Enchanted European fairytale lore, mossy ancient castles, whispering fairy forests and soft golden magic';
      case 'Hiện đại tối giản neon':
        return 'Sleek modern minimalist geometry with subtle glowing luminous neon accents and crisp clean lines';
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
      case 'Cam Hoàng Hôn & Nâu Đất':
        return 'warm amber sunset orange and earthy terracotta brown';
      case 'Hồng Phấn & Bạc':
        return 'soft pastel rose quartz pink and shimmering metallic silver';
      case 'Tím Than & Xanh Lá Đậm':
        return 'mysterious midnight deep violet and dark forest evergreen';
      case 'Trắng Ngà & Vàng Nhạt':
        return 'pure ivory white and delicate pale champagne gold';
      case 'Đen Tuyền & Đỏ Máu':
        return 'pitch-black obsidian and passionate blood red';
      case 'Xanh Dương Hoàng Gia & Vàng Đồng':
        return 'imperial royal sapphire blue and burnished antique brass gold';
      case 'Xanh Lục Rừng & Nâu Gỗ':
        return 'deep woodland moss green and rich rustic walnut wood brown';
      case 'Cầu Vồng Ánh Kim & Trắng':
        return 'shimmering holographic iridescent rainbow sheen and pure porcelain white';
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
